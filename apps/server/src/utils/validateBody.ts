import validator from 'validator';
import { IGenerateBody } from '../types';
import { colorHexRegex, testBase64Image } from './regex';

export const validateGenerateBody = (body: IGenerateBody) => {
  const { url, name, image64 } = body;

  if (validator.isURL(url) === false || validator.isEmpty(url)) {
    return { isValid: false, message: 'URL is required' };
  }

  if (validator.isEmpty(name)) {
    return { isValid: false, message: 'Name is required' };
  }

  if (validator.isEmpty(image64)) {
    return { isValid: false, message: 'Image is required' };
  }

  if (testBase64Image(image64)) {
    return { isValid: false, message: 'Image is not a valid base64 image' };
  }

  if (!validator.isEmpty(body.dotsColor) && !isColorHex(body.dotsColor)) {
    return { isValid: false, message: 'Dots color is not a valid hex color' };
  }

  if (!validator.isEmpty(body.edgeColor) && !isColorHex(body.edgeColor)) {
    return { isValid: false, message: 'Edge color is not a valid hex color' };
  }

  if (!validator.isEmpty(body.edgeDotColor) && !isColorHex(body.edgeDotColor)) {
    return {
      isValid: false,
      message: 'Edge dot color is not a valid hex color',
    };
  }

  return { isValid: true };
};

export function isColorHex(color: string): boolean {
  return colorHexRegex.test(color);
}
