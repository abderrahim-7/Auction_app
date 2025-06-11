import 'package:enchere_app/UI/Root.dart';
import 'package:flutter/material.dart';
import 'package:enchere_app/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class retirerSolde extends StatefulWidget {
  const retirerSolde({super.key});

  @override
  State<retirerSolde> createState() => _retirerSoldeState();
}

class _retirerSoldeState extends State<retirerSolde> {
  final TextEditingController montantController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController ribController = TextEditingController();

  bool montantError = false;
  bool nomError = false;
  bool bankError = false;
  bool ribError = false;

  // ---------- helpers ----------
  InputDecoration _decoration(String hint, bool error) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
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

  Widget _errorText(bool error) =>
      error
          ? const Padding(
            padding: EdgeInsets.only(top: 5, left: 10),
            child: Text(
              'Donnée invalide',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          )
          : const SizedBox.shrink();

  bool _validate() {
    setState(() {
      final montant = int.tryParse(montantController.text);
      montantError = montant == null || montant <= 0;

      nomError = nomController.text.isEmpty;
      bankError = bankController.text.isEmpty;

      ribError = !RegExp(r'^\d{24}$').hasMatch(ribController.text);
    });

    return !(montantError || nomError || bankError || ribError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Retirer",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 132, 162),
            fontSize: 30,
          ),
        ),
        leading: BackButton(
          style: ButtonStyle(
            iconSize: const MaterialStatePropertyAll(40),
            iconColor: const MaterialStatePropertyAll(
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
              const Text("Montant", style: TextStyle(fontSize: 24)),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: montantController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration(
                        'Entrer le montant',
                        montantError,
                      ),
                    ),
                    _errorText(montantError),
                  ],
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              const Text("Paiement", style: TextStyle(fontSize: 24)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom complet
                    const Text("Nom complet", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        TextField(
                          controller: nomController,
                          decoration: _decoration('', nomError),
                        ),
                        _errorText(nomError),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Banque
                    const Text(
                      "Nom de la bank",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        TextField(
                          controller: bankController,
                          decoration: _decoration('', bankError),
                        ),
                        _errorText(bankError),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // RIB
                    const Text("RIB", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        TextField(
                          controller: ribController,
                          keyboardType: TextInputType.number,
                          decoration: _decoration('', ribError),
                        ),
                        _errorText(ribError),
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
                      MaterialPageRoute(builder: (_) => Root()),
                    );
                  },
                  style: const ButtonStyle(
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 132, 162),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              // Confirmer
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_validate()) return;

                    try {
                      final userData = await getAllUserData();
                      final soldeActuel =
                          int.tryParse(userData["solde"] ?? '0') ?? 0;
                      final montantRetrait = int.parse(montantController.text);
                      final nouveauSolde = soldeActuel - montantRetrait;
                      if (nouveauSolde >= 0) {
                        await editUserData("solde", nouveauSolde.toString());

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Root()),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Solde insuffisant",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                      }
                    } catch (e) {
                      debugPrint("Erreur lors de la mise à jour du solde : $e");
                    }
                  },
                  style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 132, 162),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  child: const Text(
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
