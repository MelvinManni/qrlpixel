export const base64ImageRegex =
  /^data:image\/(png|jpeg|jpg|gif);base64,([A-Za-z0-9+/=])+$/;

export const testBase64Image = (base64Image: string): boolean => {
  return base64ImageRegex.test(base64Image);
};

export const colorHexRegex = /^#([0-9A-F]{3}){1,2}$/i;

export const mobileRegex =
  /(Mobile|Android|iPhone|iPad|Windows Phone|BlackBerry|Opera Mini|IEMobile)/i;

export const isMobile = (userAgent: string): boolean => {
  return mobileRegex.test(userAgent);
};
