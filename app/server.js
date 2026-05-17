const express = require("express");
const mysql = require("mysql2/promise");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (req, res) => {
  res.status(200).json({
    message: "Servicio desplegado correctamente en AWS",
    project: "Evaluacion Final DGITI",
    endpoint: "/health",
  });
});

app.get("/health", async (req, res) => {
  try {
    let dbStatus = "not_configured";

    const hasDbConfig =
      process.env.DB_HOST &&
      process.env.DB_USER &&
      process.env.DB_PASSWORD &&
      process.env.DB_NAME;

    if (hasDbConfig) {
      const connection = await mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        connectTimeout: 5000,
      });

      await connection.query("SELECT 1");
      await connection.end();
      dbStatus = "connected";
    }

    res.status(200).json({
      status: "ok",
      service: "aws-final-project",
      database: dbStatus,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      service: "aws-final-project",
      database: "failed",
      error: error.message,
      timestamp: new Date().toISOString(),
    });
  }
});

app.use((req, res) => {
  res.status(404).json({
    status: "not_found",
    message: "Endpoint no encontrado",
  });
});

if (require.main === module) {
  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Servidor ejecutándose en puerto ${PORT}`);
  });
}

module.exports = app;
