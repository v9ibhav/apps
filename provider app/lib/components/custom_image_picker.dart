import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomImagePicker extends StatefulWidget {
  final Function(List<File> files) onFileSelected;
  final Function(String value)? onRemoveClick;
  final List<String>? selectedImages;
  final double? height;
  final double? weight;
  final double? iconSize;
  final int? textSize;
  final double? imageSize;
  final bool isMultipleImages;
  final bool isCrop;

  CustomImagePicker({
    Key? key,
    required this.onFileSelected,
    this.selectedImages,
    this.onRemoveClick,
    this.height,
    this.weight,
    this.iconSize,
    this.textSize,
    this.imageSize,
    this.isMultipleImages = true,
    this.isCrop = false,
  }) : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    if (widget.selectedImages.validate().isNotEmpty) {
      widget.selectedImages.validate().forEach((element) {
        if (element.validate().contains("http")) {
          imageFiles.add(File(element.validate()));
        } else {
          imageFiles.add(File(element.validate()));
          widget.onFileSelected.call(imageFiles);
        }
      });
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await showInDialog(
              context,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              title: Text(languages.chooseAction, style: boldTextStyle()),
              builder: (p0) {
                return FilePickerDialog(isSelected: (false));
              },
            ).then((file) async {
              if (file != null) {
                if (file == GalleryFileTypes.CAMERA) {
                  await getCameraImage(isCrop: widget.isCrop, context: context).then((value) {
                    if (widget.isMultipleImages) {
                      if (imageFiles.validate().isNotEmpty) {
                        imageFiles.insert(0, value!);
                      } else {
                        imageFiles.add(value!);
                      }
                    } else {
                      // Replace any existing image
                      log('-------Recieved Image-----');
                      log(value != null);
                      imageFiles = [value!];
                    }
                    setState(() {});
                  });
                } else if (file == GalleryFileTypes.GALLERY) {
                  if (widget.isMultipleImages) {
                    await getMultipleImageSource().then((value) {
                      if (imageFiles.validate().isNotEmpty) {
                        value.forEach((element) {
                          imageFiles.add(element);
                        });
                      } else {
                        imageFiles = value;
                      }
                      // setState(() {});
                    });
                  } else {
                    await getCameraImage(isCamera: false, isCrop: widget.isCrop, context: context).then((value) {
                      // Replace any existing image

                      imageFiles = [value!];
                      // setState(() {});
                    });
                  }
                  setState(() {});
                }
                widget.onFileSelected.call(imageFiles);
              }
            });
          },
          child: DottedBorderWidget(
            color: context.primaryColor,
            radius: defaultRadius,
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: widget.height,
              width: widget.weight,
              decoration: boxDecorationWithShadow(blurRadius: 0, backgroundColor: context.cardColor, borderRadius: radius()),
              child: imageFiles.isNotEmpty
                  ? Image.file(
                      imageFiles.first,
                      height: widget.height,
                      width: widget.weight,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(defaultRadius)
                  : Column(
                      children: [
                        ic_no_photo.iconImage(size: 46),
                        8.height,
                        Text(languages.chooseImage, style: secondaryTextStyle()),
                      ],
                    ),
            ),
          ),
        ),
        16.height,
        Text(
          widget.isMultipleImages ? languages.selectImgNote : languages.noteYouCanUpload,
          style: secondaryTextStyle(size: 10),
        ),
        16.height,
        HorizontalList(
          itemCount: imageFiles.length,
          spacing: 16,
          itemBuilder: (context, index) {
            bool isNetworkImage = imageFiles[index].path.contains("http");
            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (isNetworkImage)
                  CachedImageWidget(
                    url: imageFiles[index].path,
                    height: widget.imageSize ?? 80,
                    width: widget.imageSize ?? 80,
                    fit: BoxFit.cover,
                    radius: defaultRadius,
                  )
                else
                  Image.file(
                    File(imageFiles[index].path),
                    height: widget.imageSize ?? 80,
                    width: widget.imageSize ?? 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return PlaceHolderWidget(height: 80, alignment: Alignment.center);
                    },
                  ).cornerRadiusWithClipRRect(defaultRadius),
                Positioned(
                  top: -22,
                  right: -20,
                  child: IconButton(
                    onPressed: () {
                      widget.onRemoveClick!.call(imageFiles[index].path);
                    },
                    icon: Icon(Icons.dangerous_outlined, color: Colors.red),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

class FilePickerDialog extends StatelessWidget {
  final bool isSelected;

  FilePickerDialog({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingItemWidget(
            title: languages.removeImage,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(Icons.close, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.CANCEL);
            },
          ).visible(isSelected),
          SettingItemWidget(
            title: languages.camera,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.camera, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.CAMERA);
            },
          ).visible(!isWeb),
          SettingItemWidget(
            title: languages.lblGallery,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.image_1, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.GALLERY);
            },
          ),
        ],
      ),
    );
  }
}