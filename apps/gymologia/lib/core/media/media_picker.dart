import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/kit.dart';
import '../api/uploads.dart';

/// One picked file, read into memory and typed.
class PickedFile {
  PickedFile({required this.bytes, required this.name, required this.contentType});
  final Uint8List bytes;
  final String name;
  final String contentType;

  bool get isPdf => contentType == 'application/pdf';
}

enum _Source { camera, gallery, file }

/// Where the file should come from. Photos: camera or gallery. Documents
/// add "a file", for a PDF someone already has.
Future<_Source?> _askSource(BuildContext context, {required bool allowFiles}) {
  final t = AppLocalizations.of(context);
  return showModalBottomSheet<_Source>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionTile(
              icon: Icons.photo_camera_rounded,
              title: t.takePhoto,
              accent: true,
              onTap: () => Navigator.of(ctx).pop(_Source.camera),
            ),
            const SizedBox(height: 8),
            ActionTile(
              icon: Icons.photo_library_rounded,
              title: t.chooseFromGallery,
              onTap: () => Navigator.of(ctx).pop(_Source.gallery),
            ),
            if (allowFiles) ...[
              const SizedBox(height: 8),
              ActionTile(
                icon: Icons.picture_as_pdf_rounded,
                title: t.chooseFile,
                subtitle: t.chooseFileHint,
                onTap: () => Navigator.of(ctx).pop(_Source.file),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Photos are shrunk on the phone before they leave it: a 12-megapixel
/// camera shot is several MB, the gym-images bucket takes 5, and a gym
/// browser card never needs more than ~1900 px across. Also far kinder to
/// a member on mobile data.
Future<PickedFile?> _fromImagePicker(ImageSource source) async {
  final x = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1920,
    maxHeight: 1920,
    imageQuality: 82,
  );
  if (x == null) return null;
  final type = x.mimeType ?? Uploader.contentTypeFor(x.name) ?? 'image/jpeg';
  return PickedFile(bytes: await x.readAsBytes(), name: x.name, contentType: type);
}

/// A gym or event photo, from the camera or the gallery.
Future<PickedFile?> pickPhoto(BuildContext context) async {
  final source = await _askSource(context, allowFiles: false);
  if (source == null) return null;
  return _fromImagePicker(
    source == _Source.camera ? ImageSource.camera : ImageSource.gallery,
  );
}

/// A verification document: a photo of it, or an existing PDF or image.
Future<PickedFile?> pickDocument(BuildContext context) async {
  final source = await _askSource(context, allowFiles: true);
  switch (source) {
    case null:
      return null;
    case _Source.camera:
      return _fromImagePicker(ImageSource.camera);
    case _Source.gallery:
      return _fromImagePicker(ImageSource.gallery);
    case _Source.file:
      final file = await openFile(acceptedTypeGroups: const [
        XTypeGroup(
          label: 'PDF or image',
          extensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
          mimeTypes: ['application/pdf', 'image/jpeg', 'image/png', 'image/webp'],
        ),
      ]);
      if (file == null) return null;
      final type = Uploader.contentTypeFor(file.name) ?? file.mimeType;
      if (type == null) return null;
      return PickedFile(
          bytes: await file.readAsBytes(), name: file.name, contentType: type);
  }
}
