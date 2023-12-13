import { User } from '@supabase/supabase-js';
import { Request } from 'express';
import { Database } from './database.types';

// Supabase tables
export type QR_CODE_TABLE = Database['public']['Tables']['qrcode']['Row'];
export type CLICKS_TABLE = Database['public']['Tables']['scan']['Row'];

export enum HTTPCODES {
  OK = 200,
  CREATED = 201,
  BAD_REQUEST = 400,
  UNAUTHORIZED = 401,
  NOT_FOUND = 404,
  INTERNAL_SERVER_ERROR = 500,
}

export type ReqWithUser = Request & { user: User };

export interface IGenerateBody {
  url: string;
  name: string;
  description?: string;
  image64?: string;
  dotsColor?: string;
  edgeColor?: string;
  edgeDotColor?: string;
}
