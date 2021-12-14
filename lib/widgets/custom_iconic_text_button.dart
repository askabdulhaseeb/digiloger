import 'package:flutter/material.dart';
import '../utilities/utilities.dart';

class CustomImageTextButton extends StatelessWidget {
  const CustomImageTextButton({
    required this.image,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String image;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Utilities.borderRadius / 2),
      child: Container(
        width: 220,
        padding: EdgeInsets.all(Utilities.padding / 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(Utilities.borderRadius / 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(image),
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
