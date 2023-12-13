import { Response } from 'express';
import { HTTPCODES, QR_CODE_TABLE, ReqWithUser } from '../types';
import { supabaseClient } from '../utils/supabase';
import isURL from 'validator/lib/isURL';

import { validateGenerateBody } from '../utils/validateBody';
import { generateRedirectId } from '../utils/generateRedirectId';
import generateQRCode from '../utils/generateQRCode';

export const createQRCode = async (req: ReqWithUser, res: Response) => {
  try {
    // validate body
    const valid = validateGenerateBody(req.body);
    if (!valid.isValid) {
      return res.status(HTTPCODES.BAD_REQUEST).json({ message: valid.message });
    }
    // check if url  already exists for user in db
    const {
      url,
      name,
      description,
      image64,
      dotsColor,
      edgeColor,
      edgeDotColor,
    } = req.body;

    const { data } = await supabaseClient
      .from('qrcode')
      .select('image_url')
      .eq('url', url)
      .returns<Pick<QR_CODE_TABLE, 'image_url'>>()
      .single();

    // throw error if it does
    if (data) {
      return res
        .status(HTTPCODES.BAD_REQUEST)
        .json({ message: 'URL already exists', data: data });
    }

    if (!isURL(url)) {
      return res.status(HTTPCODES.BAD_REQUEST).json({ message: 'Invalid URL' });
    }
    const randomStr = await generateRedirectId(7);
    // validate that randomString does not alredy exist

    const redirectUrl = `${req.hostname}/${randomStr}`;

    // generate code
    const qrCode = await generateQRCode({
      redirectUrl,
      image: image64,
      dotsColor,
      edgeColor,
      edgeDotColor,
    });

    // upload to supabse stoorage
    const { error: uploadError } = await supabaseClient.storage
      .from('qrcode/images')
      .upload(`${randomStr}.png`, qrCode);

    if (uploadError) {
      return res
        .status(HTTPCODES.INTERNAL_SERVER_ERROR)
        .json({
          message:
            uploadError.message ?? 'Something went wrong generating QR code',
        });
    }

    // save to db
    const { error: dbError } = await supabaseClient.from('qrcode').insert({
      user_id: req.user.id,
      url,
      name,
      description,
      image_url: `${randomStr}.png`,
      redirect_id: randomStr,
    });

    if (dbError) {
      res.status(HTTPCODES.INTERNAL_SERVER_ERROR).json({
        message: dbError.message ?? 'Something went wrong saving QR code',
      });
    }

    return res.status(HTTPCODES.CREATED).json({ message: 'QR code created!' });
  } catch (error) {
    console.error(error);
    return res
      .status(HTTPCODES.INTERNAL_SERVER_ERROR)
      .json({ message: 'Something went wrong' });
  }
};
