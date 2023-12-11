import { Request, Response } from 'express';
import { HTTPCODES } from '../types';

export default function authenticate(
  req: Request,
  res: Response,
) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(HTTPCODES.BAD_REQUEST).json({ message: 'Authentication failed' });
  } 
}
