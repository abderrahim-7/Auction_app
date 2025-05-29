import 'package:enchere_app/UI/Root.dart';
import 'package:flutter/material.dart';
import 'package:enchere_app/services/database.dart';

class rechargerSolde extends StatelessWidget {
  rechargerSolde({super.key});

  final TextEditingController montantController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          Row(
            spacing: 5,
            children: [
              BackButton(
                style: ButtonStyle(
                  iconSize: WidgetStatePropertyAll(40),
                  iconColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 0, 132, 162),
                  ),
                ),
              ),
              Text(
                'Recharger',
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
              Text("Montant", style: TextStyle(fontSize: 24)),
              Container(
                width: 300,
                child: TextField(
                  controller: montantController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Entrer le montant',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text("Paiement", style: TextStyle(fontSize: 24)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom porteur
                    Text(
                      "Nom du porteur de la carte",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Numéro carte
                    Text("Numéro de la carte", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    TextField(
                      controller: numeroController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Date d'expiration",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 5),
                              TextField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),

                        // CVV
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 65),
                                child: Text(
                                  "CVV",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),

                              SizedBox(height: 5),
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                width: 160,
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
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> userData = await getUserData();
                      String soldeActuelStr = userData["solde"];
                      int soldeActuel = int.tryParse(soldeActuelStr) ?? 0;

                      int montant = int.tryParse(montantController.text) ?? 0;

                      int nouveauSolde = soldeActuel + montant;

                      await editUserData("solde", nouveauSolde.toString());

                      print("Solde mis à jour avec succès : $nouveauSolde");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Root()),
                      );
                    } catch (e) {
                      print("Erreur lors de la mise à jour du solde : $e");
                    }
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
                      fontSize: 22,
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
