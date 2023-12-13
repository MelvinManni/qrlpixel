import { Router } from "express";
import { handleRedirect } from "../controllers/redirect.controllers";

const router = Router();

router.get("/:redirectId", handleRedirect);

export default router;