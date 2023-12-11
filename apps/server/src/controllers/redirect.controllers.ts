import { Request, Response } from 'express';
import { supabaseClient } from '../utils/supabase';
import { HTTPCODES, QR_CODE_TABLE } from '../types';
import { lookup } from 'geoip-country';

export const handleRedirect = async (req: Request, res: Response) => {
  // get redirect id from params
  const { redirectId } = req.params;
  try {
    //  get url from db
    const { data, error } = await supabaseClient
      .from('qrcode')
      .select('*')
      .eq('redirect_id', redirectId)
      .maybeSingle();

    if (error) {
      return res
        .status(HTTPCODES.INTERNAL_SERVER_ERROR)
        .json({ message: error.message });
    }

    if (!data) {
      return res.status(HTTPCODES.NOT_FOUND).json({ message: 'Not found!' });
    }

    data as QR_CODE_TABLE;

    // get user ip
    const ip = req.socket.remoteAddress;

    const { country } = lookup(ip);

    /**
     * @todo get client device info Mobile/Desktop
     */

    const { error: scanError } = await supabaseClient.from('scan').insert([
      {
        qrcode: data.id,
        ip,
        country,
      },
    ]);

    if (scanError) {
      return res
        .status(HTTPCODES.INTERNAL_SERVER_ERROR)
        .json({ message: scanError.message });
    }

    //  redirect to url
    res.redirect(data.url);
  } catch (error) {
    return res
      .status(HTTPCODES.INTERNAL_SERVER_ERROR)
      .json({ message: error.message ?? 'Something went wrong' });
  }
};
