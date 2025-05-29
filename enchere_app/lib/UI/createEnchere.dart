import 'package:dotted_border/dotted_border.dart';
import 'package:enchere_app/UI/Root.dart';
import 'package:enchere_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateEnchere extends StatefulWidget {
  const CreateEnchere({super.key});

  @override
  State<CreateEnchere> createState() => _CreateEnchereState();
}

class _CreateEnchereState extends State<CreateEnchere> {
  List<String> uploadedImages = [];
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          // Back button
          Row(
            spacing: 5,
            children: [
              BackButton(
                color: Color.fromARGB(255, 0, 132, 162),
                style: ButtonStyle(iconSize: WidgetStatePropertyAll(40)),
              ),
              Text(
                'Création',
                style: TextStyle(
                  fontSize: 32,
                  color: Color.fromARGB(255, 0, 132, 162),
                ),
              ),
            ],
          ),
          Column(
            spacing: 10,
            children: [
              // Image Upload
              GestureDetector(
                onTap: () async {
                  String imageUploaded = await uploadImage("");
                  if (imageUploaded.isNotEmpty) {
                    setState(() {
                      uploadedImages.add(imageUploaded);
                    });
                  }
                },
                child: DottedBorder(
                  options: RectDottedBorderOptions(dashPattern: [5, 2]),
                  child: Container(
                    height: 230,
                    width: 320,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/upload.png"),
                            ),
                          ),
                        ),
                        Text(
                          "Télécharger les images du produit",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Uploaded Images
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children:
                      uploadedImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        String url = entry.value;

                        return Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  uploadedImages.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),

          // informations de l'enchère
          Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 132, 162),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Nom du produit : ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.only(bottom: 12.5),
                      width: 240,
                      child: TextField(
                        maxLength: 50,
                        controller: nomController,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Description : ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 132, 162),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 240,
                      padding: EdgeInsets.only(bottom: 3),
                      child: TextField(
                        maxLines: null,
                        maxLength: 200,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 132, 162),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 132, 162),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Adresse : ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.only(bottom: 12.5),
                      width: 240,
                      child: TextField(
                        maxLength: 100,
                        controller: adresseController,
                        decoration: InputDecoration(
                          counterText: "",

                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Mode : ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 132, 162),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 20),

                    Text(
                      "Temps limité",
                      style: TextStyle(
                        color:
                            isOnline
                                ? Color.fromARGB(255, 0, 98, 120)
                                : Colors.green,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 20),
                    FlutterSwitch(
                      width: 55.0,
                      height: 30.0,
                      toggleSize: 25.0,
                      value: isOnline,
                      borderRadius: 30.0,
                      activeColor: Color.fromARGB(255, 0, 202, 216),
                      inactiveColor: Colors.green,
                      toggleColor: Colors.white,
                      onToggle: (val) {
                        setState(() {
                          isOnline = val;
                        });
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      "En ligne",
                      style: TextStyle(
                        color:
                            isOnline
                                ? Color.fromARGB(255, 0, 202, 216)
                                : Color.fromARGB(255, 0, 98, 120),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 132, 162),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Prix : ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.only(bottom: 12.5),
                      width: 240,
                      child: TextField(
                        maxLength: 20,
                        controller: prixController,
                        decoration: InputDecoration(
                          counterText: "",

                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isOnline)
                Container(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Durée : ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 132, 162),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.only(bottom: 12.5),
                        width: 240,
                        child: TextField(
                          maxLength: 20,
                          controller: timeController,
                          decoration: InputDecoration(
                            counterText: "",

                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 132, 162),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                    );
                  },
                  style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 1.5,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  child: Text(
                    "Annuler",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 132, 162),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    createEnchereData(
                      nomController.text,
                      descriptionController.text,
                      adresseController.text,
                      isOnline ? "En ligne" : "Temps limité",
                      prixController.text,
                      uploadedImages.removeAt(0),
                      uploadedImages,
                      isOnline ? '00 : 01 : 00' : timeController.text,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                    );
                  },

                  style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 132, 162),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  child: Text(
                    "Confirmer",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
