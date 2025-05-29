import 'package:flutter/material.dart';

class Enchereinfos extends StatefulWidget {
  const Enchereinfos({super.key});

  @override
  State<Enchereinfos> createState() => _EnchereinfosState();
}

class _EnchereinfosState extends State<Enchereinfos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.blue),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
