import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  final String location;
  final Function() press;
  const LocationListTile(
      {Key? key, required this.location, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.location_pin),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 222, 219, 219),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
