import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final IconData ?icon;
  final Function()? onPressed;
  const CustomCard({
    Key? key,
    this.title,
    this.subtitle,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      items: [
        SettingsItem(
          onTap: widget.onPressed!,
          icons: widget.icon!,
          iconStyle: IconStyle(
            backgroundColor: Colors.black,
          ),
          title: widget.title!,
          titleStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Baloo2',
          ),
          subtitle: widget.subtitle!,
          subtitleStyle: TextStyle(
            color: Colors.black,
            fontSize: 10,
          
          ),
        ),
      ],
    );
  }
}
