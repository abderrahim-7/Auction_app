import 'package:flutter/material.dart';
import 'package:enchere_app/UI/login.dart';
import 'package:enchere_app/services/Authentification.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController paysController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Register_background.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "S'inscrire",
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 0, 132, 162),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        createTextField("Nom", nomController),
                        createTextField("Prénom", prenomController),
                        createTextField(
                          "Date de naissance (jj/mm/aaaa)",
                          dateNaissanceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Date de naissance requise.";
                            } else if (!RegExp(
                              r'^\d{2}/\d{2}/\d{4}$',
                            ).hasMatch(value)) {
                              return "Format invalide. Utilisez jj/mm/aaaa.";
                            }
                            return null;
                          },
                        ),
                        createTextField("Pays", paysController),
                        createTextField("Adresse", adresseController),
                        createTextField(
                          "Numéro de téléphone",
                          telephoneController,
                        ),
                        createTextField("Email", emailController),
                        createTextField(
                          "Mot de passe",
                          passwordController,
                          isPassword: true,
                        ),
                        createTextField(
                          "Confirmer mot de passe",
                          confirmPasswordController,
                          isPassword: true,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Les mots de passe ne correspondent pas.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Authentification().signup(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                        Nom: nomController.text,
                        Prenom: prenomController.text,
                        DateNaissance: dateNaissanceController.text,
                        Pays: paysController.text,
                        Adresse: adresseController.text,
                        numTel: telephoneController.text,
                      );
                    }
                  },
                  style: const ButtonStyle(
                    side: MaterialStatePropertyAll(
                      BorderSide(
                        color: Color(0xFF01CEFF),
                        width: 4,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  ),
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(
                      color: Color(0xFF01CEFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous avez un compte,",
                        style: TextStyle(
                          color: Color.fromARGB(225, 121, 120, 120),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Color.fromRGBO(16, 44, 227, 1),
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.center,
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label est requis.';
              }
              return null;
            },
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Color.fromRGBO(120, 121, 121, 1)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF01CEFF), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF01CEFF), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
