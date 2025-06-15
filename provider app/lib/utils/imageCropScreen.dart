import 'dart:io';
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:path_provider/path_provider.dart';

class CropImageScreen extends StatefulWidget {
  final File imageFile;

  const CropImageScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  late CropController _controller;
  late File _currentImage;

  @override
  void initState() {
    super.initState();
    debugPrint('Initial image selected: ${widget.imageFile.path}');
    _currentImage = widget.imageFile;
    _controller = CropController(aspectRatio: 2.0);
  }

  @override
  void didUpdateWidget(covariant CropImageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFile.path != oldWidget.imageFile.path) {
      debugPrint('New image selected: ${widget.imageFile.path}');
      setState(() {
        _currentImage = widget.imageFile;
        _controller.dispose();
        _controller = CropController(aspectRatio: 2.0);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Crop Image',
      actions: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: () async {
            final croppedImage = await _controller.croppedBitmap();
            final byteData = await croppedImage.toByteData(format: ImageByteFormat.png);
            if (byteData != null) {
              final imageBytes = byteData.buffer.asUint8List();
              final directory = await getTemporaryDirectory();
              final path = '${directory.path}/${_currentImage.path.split('/').last}_cropped_image.png';
              File croppedFile = File(path);
              await croppedFile.writeAsBytes(imageBytes);

              if (mounted) {
                Navigator.pop(context, croppedFile);
              }
            }
                    },
        ),
      ],
      body: Center(
        child: CropImage(
          key: ValueKey(_currentImage.path), // Ensures widget rebuilds
          image: Image.file(_currentImage),
          controller: _controller,
          alwaysMove: true,
        ),
      ),
    );
  }
}