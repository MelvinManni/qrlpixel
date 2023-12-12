import { Router } from 'express';
import { createQRCode } from '../controllers/qrcode.controllers';

const router = Router();

router.post('/', createQRCode);

export default router;
