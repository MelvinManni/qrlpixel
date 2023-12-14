export default function base64toBlob(
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

  const byteCharacters = atob(b64Data);
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
