import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatelessWidget {
  CustomImagePicker({
    super.key,
    required this.setImage,
    this.imagePicked,
    this.imageUrl,
  });

  final void Function(XFile?) setImage;
  final XFile? imagePicked;
  final String? imageUrl;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pickImage(context);
      },
      child: Container(
        width: 178,
        height: 128,
        decoration: BoxDecoration(
          color: CustomPalette.secondary[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: imagePicked != null || imageUrl != null
              ? Stack(
                  children: [
                    imagePicked != null
                        ? Image.asset(
                            imagePicked?.path as String,
                            width: 158,
                            height: 158,
                          )
                        : Image.network(
                            imageUrl as String,
                            width: 158,
                            height: 158,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image_outlined,
                              size: 100,
                            ),
                          ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: () {
                          setImage(null);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: CustomPalette.error,
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 30,
                      color: CustomPalette.primary[100] as Color,
                    ),
                    const Text(
                      "Upload your Logo here,or select a file",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
      if (image != null) {
        _cropImage(image);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _cropImage(XFile? pickedFile) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setImage(XFile(croppedFile.path));
      }
    }
  }
}
