import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {required this.text,
      required this.onTap,
      this.hollowButton = true,
      Key? key})
      : super(key: key);
  final String text;
  final bool hollowButton;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(2),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Theme.of(context).primaryColor),
          color: hollowButton ? Colors.white : Theme.of(context).primaryColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: hollowButton ? Theme.of(context).primaryColor : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }
}
