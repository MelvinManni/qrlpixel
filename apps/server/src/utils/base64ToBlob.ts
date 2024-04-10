import sharp from 'sharp';

export default async function base64toBlob(
  b64Data: string,
  contentType?: string,
  sliceSize = 512
) {
  const dataParts = b64Data.split(',');

  if (dataParts.length > 1 && dataParts[0].includes('base64')) {
    // If the base64 string includes a content type, use it
    contentType = dataParts[0].split(';')[0].split(':')[1] || '';
    b64Data = dataParts[1];
  } else if (!contentType) {
    // If no content type is provided and no content type is included in the base64 string, set default to 'image/png'
    contentType = 'image/png';
  }

  const roundedImage = await createRoundedImageBlob(
    Buffer.from(b64Data, 'base64'),
    8
  );

  const byteCharacters = atob(roundedImage.toString('base64'));
  const byteArrays = Array.from(
    { length: Math.ceil(byteCharacters.length / sliceSize) },
    (_, index) => {
      const start = index * sliceSize;
      const end = start + sliceSize;
      const slice = byteCharacters.slice(start, end);
      return new Uint8Array(slice.split('').map((char) => char.charCodeAt(0)));
    }
  );

  return new Blob(byteArrays, { type: contentType });
}

async function createRoundedImageBlob(
  imageBuffer: Buffer,
  radius: number
): Promise<Buffer> {
  const image = sharp(imageBuffer);
  // const metadata = await image.metadata();

  // const width = metadata.width;
  // const height = metadata.height;

  const mask = Buffer.from(
    `
  <svg xmlns="http://www.w3.org/2000/svg" width="204" height="204">
    <g>
      <rect
        transform="rotate(45 102 102)"
        rx="${radius ?? 8}"
        height="135"
        width="135"
        y="34.5"
        x="34.5"
      />
    </g>
  </svg>
  `
  );

  // Create a rounded rectangle mask with transparent background
  // const maskBuffer = await sharp({
  //   create: {
  //     width,
  //     height,
  //     channels: 4, // RGBA for transparency
  //     background: { r: 0, g: 0, b: 0, alpha: 0 }, // Transparent background
  //   },
  // });

  // Apply the mask to the original image
  return image
    .composite([
      {
        input: mask,
        blend: 'dest-in',
      },
    ])
    .png()
    .toBuffer();
}
