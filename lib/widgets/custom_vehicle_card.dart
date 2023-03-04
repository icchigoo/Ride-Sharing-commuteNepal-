// import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
// import 'package:flutter/material.dart';

// class CustomVehicleCard extends StatefulWidget {
//   final String? vehicletype;
//   final String? price;
//   final FileImage? image;
//   final String? distance;
//   final Function()? onPressed;
//   const CustomVehicleCard({
//     Key? key,
//     this.vehicletype,
//     this.price,
//     this.image, 
//     this.distance,
//     this.onPressed,
//   }) : super(key: key);

//   @override
//   State<CustomVehicleCard> createState() => _CustomVehicleCardState();
// }

// class _CustomVehicleCardState extends State<CustomVehicleCard> {
//   @override
//   Widget build(BuildContext context) {
//     return SettingsGroup(
//       items: [
//         SettingsItem(
//           onTap: widget.onPressed!,
//           icons: widget.image!!,
//           iconStyle: IconStyle(
//             backgroundColor: Colors.black,
//           ),
//           vehicletype: widget.vehicletype!,
//           titleStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Baloo2',
//           ),
//           price: widget.price!,
//           subtitleStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }
