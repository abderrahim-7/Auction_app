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

  List<String> allCategories = [
    'Electronique',
    'Maison',
    'Vêtements',
    'Jeux',
    'Gaming',
    'Sport',
    'Phone',
    'Art',
    'Véhicules',
  ];

  List<String> selectedCategories = [];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Détails de l'enchère",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 132, 162),
            fontSize: 24,
          ),
        ),
        leading: BackButton(
          style: ButtonStyle(
            iconSize: MaterialStatePropertyAll(40),
            iconColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 0, 132, 162),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DottedBorder(
                  options: const RectDottedBorderOptions(dashPattern: [5, 2]),
                  child: Container(
                    height: 230,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/upload.png"),
                            ),
                          ),
                        ),
                        const Text(
                          "Télécharger les images du produit",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Uploaded Images
            if (uploadedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                        uploadedImages.asMap().entries.map((entry) {
                          int index = entry.key;
                          String url = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
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
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // Nom du produit
            _buildFieldContainer(
              label: "Nom du produit",
              controller: nomController,
              backgroundColor: const Color.fromARGB(255, 0, 132, 162),
              textColor: Colors.white,
              maxLength: 50,
            ),

            // Description
            _buildFieldContainer(
              label: "Description",
              controller: descriptionController,
              backgroundColor: Colors.white,
              textColor: const Color.fromARGB(255, 0, 132, 162),
              maxLength: 200,
              height: 80,
              maxLines: null,
            ),

            // Adresse
            _buildFieldContainer(
              label: "Adresse",
              controller: adresseController,
              backgroundColor: const Color.fromARGB(255, 0, 132, 162),
              textColor: Colors.white,
              maxLength: 100,
            ),

            // Mode Switch
            Container(
              height: 40,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    "Mode : ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 132, 162),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Temps limité",
                    style: TextStyle(
                      color:
                          isOnline
                              ? const Color.fromARGB(255, 0, 98, 120)
                              : Colors.green,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                  FlutterSwitch(
                    width: 55.0,
                    height: 30.0,
                    toggleSize: 25.0,
                    value: isOnline,
                    borderRadius: 30.0,
                    activeColor: const Color.fromARGB(255, 0, 202, 216),
                    inactiveColor: Colors.green,
                    toggleColor: Colors.white,
                    onToggle: (val) {
                      setState(() {
                        isOnline = val;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "En ligne",
                    style: TextStyle(
                      color:
                          isOnline
                              ? const Color.fromARGB(255, 0, 202, 216)
                              : const Color.fromARGB(255, 0, 98, 120),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Catégorie
            const SizedBox(height: 10),
            Container(
              height: 40,
              color: const Color.fromARGB(255, 0, 132, 162),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    "Catégorie : ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 30),
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: selectedCategory,
                    hint: const Text(
                      "Sélectionner",
                      style: TextStyle(color: Colors.white),
                    ),
                    items:
                        allCategories
                            .where((cat) => !selectedCategories.contains(cat))
                            .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 132, 162),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                    onChanged: (newValue) {
                      if (newValue != null &&
                          !selectedCategories.contains(newValue) &&
                          selectedCategories.length < 3) {
                        setState(() {
                          selectedCategories.add(newValue);
                          selectedCategory = null;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 0, 132, 162),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Wrap(
                spacing: 8.0,
                children:
                    selectedCategories.map((category) {
                      return Chip(
                        label: Text(category),
                        backgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 132, 162),
                        ),
                        deleteIcon: const Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 0, 132, 162),
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedCategories.remove(category);
                          });
                        },
                      );
                    }).toList(),
              ),
            ),

            // Prix
            _buildFieldContainer(
              label: "Prix",
              controller: prixController,
              backgroundColor: Colors.white,
              textColor: const Color.fromARGB(255, 0, 132, 162),
              maxLength: 20,
            ),

            // Durée (si offline)
            if (!isOnline)
              _buildFieldContainer(
                label: "Durée",
                controller: timeController,
                backgroundColor: const Color.fromARGB(255, 0, 132, 162),
                textColor: Colors.white,
                maxLength: 20,
              ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  "Annuler",
                  Colors.white,
                  const Color.fromARGB(255, 0, 132, 162),
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                    );
                  },
                ),
                _buildButton(
                  "Confirmer",
                  const Color.fromARGB(255, 0, 132, 162),
                  Colors.white,
                  () {
                    // Validate fields
                    if (nomController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty ||
                        adresseController.text.trim().isEmpty ||
                        prixController.text.trim().isEmpty ||
                        (!isOnline && timeController.text.trim().isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Veuillez remplir tous les champs obligatoires.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (uploadedImages.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Veuillez télécharger au moins 3 images.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    createEnchereData(
                      nomController.text,
                      descriptionController.text,
                      adresseController.text,
                      isOnline ? "En ligne" : "Temps limité",
                      prixController.text,
                      uploadedImages[0],
                      uploadedImages.sublist(1),
                      isOnline ? '00 : 02 : 00' : timeController.text,
                      selectedCategories,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldContainer({
    required String label,
    required TextEditingController controller,
    required Color backgroundColor,
    required Color textColor,
    required int maxLength,
    int? maxLines,
    double height = 40,
  }) {
    return Container(
      height: height,
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Text("$label : ", style: TextStyle(color: textColor, fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: label == "Description" ? 0 : 12),
              child: TextField(
                maxLines: maxLines ?? 1,
                maxLength: maxLength,
                controller: controller,
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: 140,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          side:
              backgroundColor == Colors.white
                  ? const WidgetStatePropertyAll(
                    BorderSide(
                      color: Color.fromARGB(255, 0, 132, 162),
                      width: 1.5,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  )
                  : null,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
