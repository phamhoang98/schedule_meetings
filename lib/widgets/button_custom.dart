import 'package:flutter/material.dart';
import 'package:schedule_meetings/constants/color.dart';

class ButtonOutline extends StatelessWidget {
  const ButtonOutline(
      {Key? key,
        required this.text,
        this.onPressed,
        this.imageName,
        this.width,
        this.maxWidth,
        this.borderColor,
        this.textColor,
        this.height,
        this.fontWeight,
        this.fontSize,
        this.bgColor,
        this.borderRadius,
        this.padding,
        this.imageSize})
      : super(key: key);
  final String text;
  final String? imageName;
  final VoidCallback? onPressed;
  final double? width, height, fontSize, borderRadius, imageSize;
  final bool? maxWidth;
  final Color? borderColor, textColor, bgColor;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth == true ? double.infinity : width,
      height: height ?? 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: bgColor ?? Colors.green,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor ,
              fontWeight: fontWeight ?? FontWeight.w600,
              fontSize: fontSize ?? 14),
        ),
      ),
    );
  }
}
