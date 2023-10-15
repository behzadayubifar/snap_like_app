import 'package:flutter/material.dart';
import 'package:snap_like_app/constants/dimens.dart';

class MyBackButton extends StatelessWidget {
  final Function() onPressed;

  const MyBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: Dimens.medium,
      right: Dimens.medium,
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 3),
              blurRadius: 18,
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }
}
