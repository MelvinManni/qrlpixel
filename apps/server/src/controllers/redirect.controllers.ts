import { Request, Response } from 'express';
import { supabaseClient } from '../utils/supabase';
import { HTTPCODES, QR_CODE_TABLE } from '../types';
import { lookup } from 'geoip-country';
import { isMobile } from '../utils/regex';

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
    const ip = req.ip ?? req.socket.remoteAddress ?? '';

    const val = lookup(ip);
    const country = val?.country ?? 'Unknown';

    const device = isMobile(req.headers['user-agent']) ? 'Mobile' : 'Desktop';
    supabaseClient
      .from('scan')
      .insert([
        {
          qrcode: data.id,
          ip,
          country,
          device,
        },
      ])
      .then(undefined, (error) => {
        if (error) {
          console.log("Error! Couldn't insert scan data", error);
        }
      });
    res.redirect(data.url);
  } catch (error) {
    return res
      .status(HTTPCODES.INTERNAL_SERVER_ERROR)
      .json({ message: error.message ?? 'Something went wrong' });
  }
};
