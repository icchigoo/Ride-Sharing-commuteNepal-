import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  final bool? loading;
  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.loading,
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
        child: Center(
          child: widget.loading!
              ? const CupertinoActivityIndicator(
                  radius: 12,
                  animating: true,
                  color: Colors.white,
                )
              : Text(
                  widget.text!,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
