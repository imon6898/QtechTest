import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String btnText;
  final Function()? onPressed;
  final bool loading;
  const CommonButton({Key? key, required this.btnText, required this.onPressed, required this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.square(50), // Width and height are the same (50)
        backgroundColor: Color(0xFF100C94),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Set border radius here
        ),
      ),
      child: loading
          ? SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(),
      )
          : Text(
        btnText,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
