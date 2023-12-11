import { NextFunction, Request, Response } from 'express';
import { HTTPCODES } from '../types';
import { supabaseClient } from '../utils/supabase';

export default async function authenticate(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res
      .status(HTTPCODES.BAD_REQUEST)
      .json({ message: 'Authentication failed' });
  }

  const user = await supabaseClient.auth.getUser(token);

  if (!user) {
    return res
      .status(HTTPCODES.UNAUTHORIZED)
      .json({ message: 'Authentication failed' });
  }

  req['user'] = user.data.user;

  next();
}
