import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImportImage extends StatefulWidget {
  final String label;
  final String? imageUrl;
  final Function(XFile?) setXFile;
  final double? maxHeightImage;
  final double? maxWidthImage;

  const AppImportImage({
    Key? key,
    this.label = '',
    this.imageUrl,
    required this.setXFile,
    this.maxHeightImage,
    this.maxWidthImage,
  }) : super(key: key);

  @override
  State<AppImportImage> createState() => _AppImportImageState();
}

class _AppImportImageState extends State<AppImportImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _xfile;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _xfile != null
          ? Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: kIsWeb
                  ? Image.network(
                      _xfile!.path,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return errorBuilderWidget();
                      },
                    )
                  : Image.file(
                      File(_xfile!.path),
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return errorBuilderWidget();
                      },
                    ),
            )
          : widget.imageUrl == null
              ? Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.imageUrl!,
                    height: 150,
                    width: 150,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return errorBuilderWidget();
                    },
                  ),
                ),
      onTap: () async {
        final XFile? pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            maxHeight: widget.maxHeightImage,
            maxWidth: widget.maxWidthImage);

        if (pickedFile != null) {
          widget.setXFile(pickedFile);
          setState(() {
            _xfile = pickedFile;
          });
        }
      },
    );
  }

  Container errorBuilderWidget() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Center(
        child: Text('Erro ao buscar esta imagem'),
      ),
    );
  }
}
