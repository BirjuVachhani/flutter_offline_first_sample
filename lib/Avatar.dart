import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  final String _imageUrl;
  final double size;

  NetworkAvatar(this._imageUrl, {this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(size, size),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56.0),
        child: CachedNetworkImage(
          imageUrl: _imageUrl,
          placeholder: (context, url) =>
              Image.asset("assets/images/avatar_placeholder.png"),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      ),
    );
  }
}
