import 'package:reliance_app/constants/styles.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final double size;

  RatingStar(this.rating, this.size);

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
        starCount: 5,
        rating: rating,
        size: size,
        isReadOnly: true,
        filledIconData: Icons.star,
        color: Styles.appCanvasYellow,
        borderColor: Styles.colorGrey,
        spacing: 2);
  }
}
