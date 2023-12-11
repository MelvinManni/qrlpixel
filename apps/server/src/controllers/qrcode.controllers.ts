import { Response } from 'express';
import { HTTPCODES, QR_CODE_TABLE, ReqWithUser } from '../types';
import { supabaseClient } from '../utils/supabase';

export const generateQRCode = async (req: ReqWithUser, res: Response) => {
  try {
    // check if url  already exists for user in db
   const url = req.body.url;

    const { data } = await supabaseClient
      .from('qrcode')
      .select('image_url')
      .eq('url', url).returns<Pick<QR_CODE_TABLE, "image_url">>()
      .single();

    // throw error if it does
    if (data) {
      return res
        .status(HTTPCODES.BAD_REQUEST)
        .json({ message: 'URL already exists', data: data });
    }

    // generate code
  } catch (error) {
    console.error(error);
    return res
      .status(HTTPCODES.INTERNAL_SERVER_ERROR)
      .json({ message: 'Something went wrong' });
  }
};
