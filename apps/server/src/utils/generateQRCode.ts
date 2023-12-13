import { QRCodeCanvas } from '@loskir/styled-qr-code-node';

interface IGenerateQRCode {
  redirectUrl: string;
  image?: string;
  dotsColor?: string;
  edgeColor?: string;
  edgeDotColor?: string;
}

export default async function ({
  image,
  redirectUrl,
  dotsColor,
  edgeColor,
  edgeDotColor,
}: IGenerateQRCode): Promise<Blob> {
  const qrcode = new QRCodeCanvas({
    width: 300,
    height: 300,
    data: redirectUrl,
    image:
      image ??
      'https://sjuqrwtxfuztuyzbviwr.supabase.co/storage/v1/object/public/qrcode/qrl_pixel_logo.png',
    imageOptions: {
      imageSize: 0.3,
      hideBackgroundDots: true,
    },
    dotsOptions: {
      color: dotsColor || '#000',
      type: 'extra-rounded',
    },
    cornersDotOptions: {
      color: edgeDotColor || '#000',
      type: 'dot',
    },
    backgroundOptions: {
      color: '#fff',
    },
    cornersSquareOptions: {
      type: 'extra-rounded',
      color: edgeColor || '#000',
    },
  });

  const buffer = await qrcode.toBuffer('png');

  //   retrun image blob
  return new Blob([buffer], { type: 'image/png' });
}
