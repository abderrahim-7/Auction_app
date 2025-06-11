import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:enchere_app/UI/login.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final TextEditingController emailController = TextEditingController();

  void sendResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email de réinitialisation envoyé.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Erreur : ${e.message}";
      if (e.code == 'user-not-found') {
        message = "Aucun utilisateur trouvé avec cet email.";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Login_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mot de passe',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 0, 132, 162),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'oublié',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 0, 132, 162),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 60, 40, 70),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(150, 150, 149, 1),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF01CEFF),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF01CEFF),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => sendResetEmail(context),
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
                    "récupérer",
                    style: TextStyle(
                      color: Color(0xFF01CEFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "vérifie votre email aprés avoir",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(150, 150, 149, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "cliqué 'récupérer'",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(150, 150, 149, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
