import { defineString } from "firebase-functions/params";
// App URL (for redirects, etc.)
export const appUrl = defineString("APP_URL", {
    default: "http://localhost:5173",
    description: "Frontend application URL for redirects",
});
//# sourceMappingURL=env.js.map