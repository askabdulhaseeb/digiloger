import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    required this.onTap,
    this.icon = CupertinoIcons.forward,
    this.iconColors,
    this.iconSize,
    this.padding,
    Key? key,
  }) : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColors;
  final double? iconSize;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding ?? 12),
          child: Icon(
            icon,
            color: iconColors ?? Theme.of(context).primaryColor,
            size: iconSize ?? 32,
          ),
        ),
      ),
    );
  }
}
