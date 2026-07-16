const { Server } = require("socket.io");
const { Client } = require("pg");
const jwt = require("jsonwebtoken");
const {env} = require("../config/env");

const activeControllers = new Map();
const activeScreens = new Map();
const activeUsers = new Map();


const JWT_SECRET = env.jwtsecret;


const pgClient = new Client({
  user: env.db.user,
  password: env.db.password,
  host: env.db.host,
  port: Number(env.db.port),
  database: env.db.database,
});

let ioInstance = null;

function createSocketServer(httpServer) {
  const io = new Server(httpServer, {
    cors: {
      origin: true,
      methods: ["GET", "POST"],
      credentials: true,
    },
  });

  ioInstance = io;

  io.use(authenticateSocket);
  io.on("connection", handleConnection);

  return io;
}

function authenticateSocket(socket, next) {
  try {
    const token = socket.handshake.auth?.token;

    if (!token) {
      return next(new Error("Token requerido"));
    }

    const decoded = jwt.verify(token, JWT_SECRET);
    socket.user = decoded;

    return next();
  } catch (error) {
    return next(new Error("No autorizado"));
  }
}

function handleConnection(socket) {
  const { sub, role, identifier } = socket.user;

  console.log("Cliente conectado:");
  console.log("Socket id:", socket.id);
  console.log("Client sub:", socket.user.sub);
  console.log("Client role:", socket.user.role);
  console.log("Client identifier:", socket.user.identifier);

  disconnectPreviousSocket(identifier);

  socket.on("ping", (data) => {
    console.log("Mensaje recibido del cliente:");
    console.log(data);

    socket.emit("pong", {
      mensaje: "Mensaje recibido correctamente",
      recibido: data,
      fecha: new Date(),
    });
  });

  if (role === "controller") {
    socket.join(`controller_${sub}`);
    activeControllers.set(identifier, socket.id);
    console.log(`Unido a room controller_${sub}`);
  }

  if (role === "screen") {
    socket.join(`screen_${sub}`);
    activeScreens.set(identifier, socket.id);
    console.log(`Pantalla unida al room screen_${sub}`);
  }

  if (role === "user") {
    socket.join(`user_${sub}`);
    activeUsers.set(identifier, socket.id);
    console.log(`User unido al room user_${sub}`);
  }

  socket.on("disconnect", () => {
    activeScreens.delete(identifier);
    activeControllers.delete(identifier);
    console.log("Cliente desconectado:", socket.id);
  });

  socket.on("sync_check", () => {
    socket.emit("sync_ok");
  });
}

function disconnectPreviousSocket(identifier) {
  if (activeControllers.has(identifier)) {
    const oldSocketId = activeControllers.get(identifier);
    ioInstance.sockets.sockets.get(oldSocketId)?.disconnect(true);
  }

  if (activeScreens.has(identifier)) {
    const oldSocketId = activeScreens.get(identifier);
    ioInstance.sockets.sockets.get(oldSocketId)?.disconnect(true);
  }

  if (activeUsers.has(identifier)) {
    const oldSocketId = activeUsers.get(identifier);
    ioInstance.sockets.sockets.get(oldSocketId)?.disconnect(true);
  }
}

function startPostgresListener() {
  return pgClient
    .connect()
    .then(async () => {
      console.log("Conectado a PostgreSQL");
      await pgClient.query("LISTEN notify_programming");
      await pgClient.query("LISTEN notify_notification");      
      await pgClient.query("LISTEN notify_position");
      console.log("Escuchando canales...");
    })
    .catch((error) => {
      console.error("Error Postgres:", error);
      throw error;
    });
}

pgClient.on("notification", async (msg) => {
  console.log("Notificación recibida:", JSON.stringify(msg));

  try {
    if (!msg.payload || msg.payload.length < 10) {
      console.log(`No hay información de payload para ${msg.channel}`);
      return;
    }

    const payload = JSON.parse(msg.payload);
    console.log(`Payload: ${JSON.stringify(payload)}`);
    const { user_id, controller_id, screen_id } = payload;

    switch (msg.channel) {
      case "notify_programming":
        console.log(`Enviando información a: controller_${controller_id}`);
        //console.log(`Enviando información a: screen_${screen_id}`);
        if (controller_id) {
          ioInstance
            .to(`controller_${controller_id}`)
            .to(`user_${user_id}`)
            .emit("notify_programming", payload);
        }
        break;
      case "notify_notification":
        console.log(`Enviando información a: user_${user_id}`);
        if (user_id) {
          ioInstance
            .to(`user_${user_id}`)
            .emit("notify_notification", payload);
        }
        break;
      case "notify_position":
        console.log(`Enviando información de posición a: user_${user_id}`);
        if (user_id) {
          ioInstance
            .to(`user_${user_id}`)
            .emit("notify_position", payload);
        }
        break;

      default:
        break;
    }

    console.log("Evento enviado correctamente");
  } catch (error) {
    console.error(error.message);
  }
});

module.exports = {
  createSocketServer,
  startPostgresListener,
};
