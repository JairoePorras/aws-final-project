import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = "http://aws-final-project-alb-1488231223.us-east-1.elb.amazonaws.com";

export const options = {
  stages: [
    { duration: "1m", target: 50 },
    { duration: "2m", target: 100 },
    { duration: "1m", target: 150 },
    { duration: "1m", target: 0 },
  ],
  thresholds: {
    http_req_failed: ["rate<0.10"],
    http_req_duration: ["p(95)<2000"],
  },
};

export default function () {
  const res = http.get(`${BASE_URL}/health`);

  check(res, {
    "status es 200": (r) => r.status === 200,
    "respuesta menor a 2000ms": (r) => r.timings.duration < 2000,
    "contiene status ok": (r) => r.body && r.body.includes("ok"),
  });

  sleep(1);
}