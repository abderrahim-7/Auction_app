import 'package:enchere_app/UI/Root.dart';
import 'package:flutter/material.dart';
import 'package:enchere_app/services/database.dart';

class rechargerSolde extends StatefulWidget {
  const rechargerSolde({super.key});

  @override
  State<rechargerSolde> createState() => _rechargerSoldeState();
}

class _rechargerSoldeState extends State<rechargerSolde> {
  final TextEditingController montantController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool montantError = false;
  bool nomError = false;
  bool numeroError = false;
  bool dateError = false;
  bool cvvError = false;

  bool validateFields() {
    setState(() {
      montantError =
          montantController.text.isEmpty ||
          int.tryParse(montantController.text) == null;
      nomError = nomController.text.isEmpty;
      numeroError =
          numeroController.text.length != 16 ||
          int.tryParse(numeroController.text) == null;
      dateError = !RegExp(r'^\d{2}/\d{2}$').hasMatch(dateController.text);
      cvvError =
          cvvController.text.length != 3 ||
          int.tryParse(cvvController.text) == null;
    });

    return !(montantError || nomError || numeroError || dateError || cvvError);
  }

  InputDecoration buildDecoration(String hintText, bool error) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
      ),
    );
  }

  Widget buildErrorText(bool error) {
    return error
        ? Padding(
          padding: EdgeInsets.only(top: 5, left: 10),
          child: Text(
            "Donnée invalide",
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recharger",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 132, 162),
            fontSize: 30,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Column(
            spacing: 10,
            children: [
              Text("Montant", style: TextStyle(fontSize: 24)),
              Container(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: montantController,
                      decoration: buildDecoration(
                        'Entrer le montant',
                        montantError,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    buildErrorText(montantError),
                  ],
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
                    // Nom
                    Text(
                      "Nom du porteur de la carte",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        TextField(
                          controller: nomController,
                          decoration: buildDecoration('', nomError),
                        ),
                        buildErrorText(nomError),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Numéro carte
                    Text("Numéro de la carte", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        TextField(
                          controller: numeroController,
                          decoration: buildDecoration('', numeroError),
                          keyboardType: TextInputType.number,
                        ),
                        buildErrorText(numeroError),
                      ],
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
                              Column(
                                children: [
                                  TextField(
                                    controller: dateController,
                                    decoration: buildDecoration('', dateError),
                                    keyboardType: TextInputType.datetime,
                                  ),
                                  buildErrorText(dateError),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),

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
                              Column(
                                children: [
                                  TextField(
                                    controller: cvvController,
                                    decoration: buildDecoration('', cvvError),
                                    keyboardType: TextInputType.number,
                                  ),
                                  buildErrorText(cvvError),
                                ],
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
                    if (!validateFields()) return;

                    try {
                      Map<String, dynamic> userData = await getAllUserData();
                      String soldeActuelStr = userData["solde"];
                      int soldeActuel = int.tryParse(soldeActuelStr) ?? 0;
                      int montant = int.tryParse(montantController.text) ?? 0;
                      int nouveauSolde = soldeActuel + montant;

                      await editUserData("solde", nouveauSolde.toString());
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
