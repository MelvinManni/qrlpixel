import { Router } from 'express';
import { createQRCode } from '../controllers/qrcode.controllers';
import authenticate from '../middleware/auth.middleware';

const router = Router();

router.use(authenticate);
router.post('/', createQRCode);

export default router;
