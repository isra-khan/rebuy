import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UniversalImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const UniversalImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      try {
        // Remove the header "data:image/png;base64," if present
        final base64String = imageUrl.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        );
      } catch (e) {
        return _buildErrorPlaceholder();
      }
    } else {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}

class UniversalImageProvider extends ImageProvider<UniversalImageProvider> {
  final String imageUrl;
  final double scale;

  const UniversalImageProvider(this.imageUrl, {this.scale = 1.0});

  @override
  Future<UniversalImageProvider> obtainKey(ImageConfiguration configuration) {
    return Future.value(this);
  }

  @override
  ImageStreamCompleter loadImage(
      UniversalImageProvider key, ImageDecoderCallback decode) {
    if (imageUrl.startsWith('data:image')) {
       try {
        final base64String = imageUrl.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return MemoryImage(bytes, scale: scale).loadImage(MemoryImage(bytes, scale: scale), decode);
      } catch (e) {
        // Fallback to empty or error logic if needed, but for ImageProvider usually rethrowing or empty is standard
        throw Exception('Invalid Base64 Image');
      }
    } else {
      return NetworkImage(imageUrl, scale: scale).loadImage(NetworkImage(imageUrl, scale: scale), decode);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is UniversalImageProvider &&
        other.imageUrl == imageUrl &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(imageUrl, scale);
}

