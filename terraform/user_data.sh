#!/bin/bash
set -e

APP_DIR="/opt/aws-final-project"
PORT="${app_port}"
DB_HOST="${db_host}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_NAME="${db_name}"

dnf update -y
dnf install -y nodejs npm

mkdir -p "$APP_DIR"
chown ec2-user:ec2-user "$APP_DIR"

cat > "$APP_DIR/package.json" <<'APP_PACKAGE'
{
  "name": "aws-final-project-runtime",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.21.2",
    "mysql2": "^3.12.0"
  }
}
APP_PACKAGE

cat > "$APP_DIR/server.js" <<'APP_SERVER'
const express = require("express");
const mysql = require("mysql2/promise");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.status(200).json({
    message: "Servicio desplegado correctamente en AWS",
    project: "Evaluacion Final DGITI",
    instance: process.env.HOSTNAME || "ec2-instance"
  });
});

app.get("/health", async (req, res) => {
  try {
    let dbStatus = "not_configured";

    if (process.env.DB_HOST && process.env.DB_USER && process.env.DB_PASSWORD && process.env.DB_NAME) {
      const connection = await mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        connectTimeout: 5000
      });

      await connection.query("SELECT 1");
      await connection.end();
      dbStatus = "connected";
    }

    res.status(200).json({
      status: "ok",
      service: "aws-final-project",
      database: dbStatus,
      instance: process.env.HOSTNAME || "ec2-instance",
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      service: "aws-final-project",
      database: "failed",
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Servidor ejecutándose en puerto $${PORT}`);
});
APP_SERVER

cat > "$APP_DIR/.env" <<APP_ENV
PORT=$PORT
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
APP_ENV=production
APP_ENV

cd "$APP_DIR"
npm install --omit=dev

cat > /etc/systemd/system/aws-final-project.service <<SERVICE
[Unit]
Description=AWS Final Project Node Service
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=$APP_DIR
EnvironmentFile=$APP_DIR/.env
ExecStart=/usr/bin/node $APP_DIR/server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable aws-final-project.service
systemctl start aws-final-project.service