import { generate } from 'randomstring';
import { supabaseClient } from './supabase';

export const generateRedirectId = async (length: number): Promise<string> => {
  const str = generate(length);
  const { data } = await supabaseClient
    .from('qrcode')
    .select('id')
    .eq('redirect_id', str)
    .single();
  if (data) {
    return generateRedirectId(length);
  }

  return str;
};
