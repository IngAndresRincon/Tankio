const { io } = require("socket.io-client");
const { env } = require("../config/env");

// Use the real backend port from .env
const SERVER_URL = `http://localhost:${env.port}`;

// Optional token
const TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjMzLCJyb2xlIjoic2NyZWVuIiwiaWRlbnRpZmllciI6IjRlZWFkYWNiNDQ0NDIxMGQiLCJpYXQiOjE3ODcwNjI5NjgsImV4cCI6MTc4OTY1NDk2OH0.7SpTU0hh4-RxWlD1T9WWlczxgr3keBM9gGp980Mi3jo";

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
