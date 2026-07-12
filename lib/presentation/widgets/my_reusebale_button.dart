import 'package:flutter/cupertino.dart';

class MyReusebaleButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color color;
  final Color textColor;

  const MyReusebaleButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
