const { io } = require("socket.io-client");
const { env } = require("../config/env");

// Use the real backend port from .env
const SERVER_URL = `http://localhost:${env.port}`;

// Optional token
const TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjIsInJvbGUiOiJjb250cm9sbGVyIiwiaWRlbnRpZmllciI6IjU1NTQzYzczLTMxZWYtNDlhNS1iZWIwLTA3YTdiNDdiYTI1MCIsImlhdCI6MTc4MTczMTEwOSwiZXhwIjoxNzg0MzIzMTA5fQ.76UCuw-6qf41r6ZTRaIXoj8JLktojhqwq1954r9el4A";

const socket = io(SERVER_URL, {
  transports: ["websocket"],
  auth: {
    token: TOKEN
  }
});

socket.on("connect", () => {
  console.log("Connected to the server");
  console.log("Socket ID:", socket.id);
  socket.emit("ping", { mensaje: "Hola servidor" });
});

socket.on("connect_error", (err) => {
  console.error("Connection error:", err.message);
});

socket.on("notify_programming", (data) => {
  console.log("Event received:");
  console.log(data);
});

socket.on("disconnect", (reason) => {
  console.log("Disconnected:", reason);
});

socket.on("pong", (data) => {
  console.log("Server response:", data);
});
