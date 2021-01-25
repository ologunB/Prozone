import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;

  CachedImage(this.imageUrl);

  final String person =
      "https://firebasestorage.googleapis.com/v0/b/proj-along.appspot.com/o/person.png?alt=media&token=54d54309-fa02-4000-b156-188ee2a38c7f";

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? person,
      fit: BoxFit.fill,
      height: 100,
      width: 100,
      placeholder: (context, url) => Image(
          image: AssetImage("images/placeholder.png"), height: 100, width: 100, fit: BoxFit.fill),
      errorWidget: (context, url, error) => Image(
          image: AssetImage("images/placeholder.png"), height: 100, width: 100, fit: BoxFit.fill),
    );
  }
}
