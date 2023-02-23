import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 23, right: 23, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        // onpressed
        onPressed: widget.onPressed,
        child: Text(
          widget.text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
