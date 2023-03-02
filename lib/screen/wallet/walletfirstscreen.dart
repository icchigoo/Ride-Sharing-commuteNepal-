import 'package:flutter/material.dart';

class WalletFirstScreen extends StatefulWidget {
  const WalletFirstScreen({super.key});

  @override
  State<WalletFirstScreen> createState() => _WalletFirstScreenState();
}

class _WalletFirstScreenState extends State<WalletFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 270, bottom: 10),
                child: Container(
                  child: const Text(
                    "Wallet",
                    style: TextStyle(fontSize: 38),
                  ),
                ),
              ),
              Container(
                width: 380.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: const Color.fromARGB(255, 238, 238, 238),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 212, 212, 212),
                      blurRadius: 6.0, // soften the shadow
                      spreadRadius: 2.0, //extend the shadow
                      offset: Offset(
                        2.0, // Move to right 5  horizontally
                        2.0, // Move to bottom 5 Vertically
                      ),
                    )
                  ],
                ),
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 22.0, right: 290),
                      child: Text(
                        ' Cash',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          color: Colors.black,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 200),
                      child: Text(
                        'NPR 0.00',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 30,
                          color: Colors.black,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, right: 200, bottom: 11),
                    child: Container(
                      child: const Text(
                        "Payment Methods",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Container(
                  width: 220.0,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44.0),
                    color: const Color.fromARGB(255, 238, 238, 238),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 20),
                    child: Container(
                      child: const Text(
                        "Add Payment Method",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 14, 14, 14)),
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
