// import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class RiderModeScreen extends StatefulWidget {
//   const RiderModeScreen({super.key});

//   @override
//   State<RiderModeScreen> createState() => _RiderModeScreenState();
// }

// class _RiderModeScreenState extends State<RiderModeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Active your rider mode as:',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Baloo2',
//               letterSpacing: 1.0,
//               wordSpacing: 1.0,
//             )),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: ListView(
//           children: [
//             // User card

//             SettingsGroup(
//               items: [
//                 SettingsItem(
//                   onTap: () {},
//                   icons: Icons.directions_bike_outlined,
//                   iconStyle: IconStyle(
//                     backgroundColor: Colors.black,
//                   ),
//                   title: 'Moto',
//                   titleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Baloo2',
//                   ),
//                   subtitle: "This feature may be available at future",
//                   subtitleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Baloo2',
//                   ),
//                 ),
//               ],
//             ),
//             SettingsGroup(
//               items: [
//                 SettingsItem(
//                   onTap: () {},
//                   icons: Icons.directions_car_outlined,
//                   iconStyle: IconStyle(
//                     backgroundColor: Colors.black,
//                   ),
//                   title: 'Car',
//                   titleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Baloo2',
//                   ),
//                   subtitle: "Wanna share your ride with other",
//                   subtitleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Baloo2',
//                   ),
//                 ),
//               ],
//             ),
//             SettingsGroup(
//               items: [
//                 SettingsItem(
//                   onTap: () {},
//                   icons: Icons.airport_shuttle,
//                   iconStyle: IconStyle(
//                     backgroundColor: Colors.black,
//                   ),
//                   title: 'Other Vehicle',
//                   titleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Baloo2',
//                   ),
//                   subtitle: "This feature may be available at future",
//                   subtitleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Baloo2',
//                   ),
//                 ),
//               ],
//             ),
//             SettingsGroup(
//               items: [
//                 SettingsItem(
//                   onTap: () {},
//                   icons: Icons.delivery_dining,
//                   iconStyle: IconStyle(
//                     backgroundColor: Colors.black,
//                   ),
//                   title: 'Courier',
//                   titleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Baloo2',
//                   ),
//                   subtitle: "This feature may be available at future,",
//                   subtitleStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Baloo2',
//                   ),
//                 ),
//               ],
//             ),
//             // You can add a settings title
//           ],
//         ),
//       ),
//     );
//   }
// }
