import 'package:flutter/material.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ride History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 50,
                                child: Icon(Icons.location_history),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "G-11, Islambaad, Pakistan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          "Rs. 200",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 30,
                                child: Icon(Icons.location_on_outlined),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Hill View Hotel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.png'),
                            radius: 22,
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20, top: 6),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Jan 28, 2022 - 3:33 PM",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color.fromARGB(255, 136, 135, 135)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: Text(
                            "Cancelled",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 204, 8, 8)),
                          ),
                        )
                      ]),
                ),
                const Divider(
                  color: Color.fromARGB(255, 186, 185, 185),
                  thickness: 1,
                  height: 12,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 50,
                                child: Icon(Icons.location_history),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "G-11, Islambaad, Pakistan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          "Rs. 110",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 30,
                                child: Icon(Icons.location_on_outlined),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Hill View Hotel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.png'),
                            radius: 22,
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20, top: 6),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Jan 28, 2022 - 5:45 PM",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color.fromARGB(255, 136, 135, 135)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: Text(
                            "Successful",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 7, 158, 48)),
                          ),
                        )
                      ]),
                ),
                const Divider(
                  color: Color.fromARGB(255, 186, 185, 185),
                  thickness: 1,
                  height: 12,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 50,
                                child: Icon(Icons.location_history),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "G-11, Islambaad, Pakistan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          "Rs. 150",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 30,
                                child: Icon(Icons.location_on_outlined),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Hill View Hotel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.png'),
                            radius: 22,
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20, top: 6),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Jan 28, 2022 - 3:33 PM",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color.fromARGB(255, 136, 135, 135)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          child: Text(
                            "Cancelled",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 204, 8, 8)),
                          ),
                        )
                      ]),
                ),
                const Divider(
                  color: Color.fromARGB(255, 186, 185, 185),
                  thickness: 1,
                  height: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
