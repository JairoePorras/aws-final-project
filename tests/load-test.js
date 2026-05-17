import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  stages: [
    { duration: "30s", target: 10 },
    { duration: "1m", target: 30 },
    { duration: "30s", target: 0 },
  ],
  thresholds: {
    http_req_failed: ["rate<0.05"],
    http_req_duration: ["p(95)<1000"],
  },
};

const BASE_URL = __ENV.BASE_URL || "http://aws-final-project-alb-1871721118.us-east-1.elb.amazonaws.com";

export default function () {
  const response = http.get(`${BASE_URL}/health`);

  check(response, {
    "status es 200": (r) => r.status === 200,
    "respuesta menor a 1000ms": (r) => r.timings.duration < 1000,
    "contiene status ok": (r) => r.body && r.body.includes("ok"),
  });

  sleep(1);
}
