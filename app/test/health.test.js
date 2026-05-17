const request = require("supertest");
const app = require("../server");

describe("API endpoints", () => {
  test("GET / debe responder 200", async () => {
    const response = await request(app).get("/");

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty("message");
    expect(response.body).toHaveProperty("endpoint", "/health");
  });

  test("GET /health debe responder estado del servicio", async () => {
    const response = await request(app).get("/health");

    expect([200, 500]).toContain(response.statusCode);
    expect(response.body).toHaveProperty("status");
    expect(response.body).toHaveProperty("service", "aws-final-project");
    expect(response.body).toHaveProperty("timestamp");
  });
});
