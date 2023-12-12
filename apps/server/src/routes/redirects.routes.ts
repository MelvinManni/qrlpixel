import { Router } from "express";
import { handleRedirect } from "../controllers/redirect.controllers";

const router = Router();

router.get("/:routeId", handleRedirect);

export default router;