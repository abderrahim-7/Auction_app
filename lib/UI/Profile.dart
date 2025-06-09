import 'package:enchere_app/UI/Notifications.dart';
import 'package:enchere_app/UI/login.dart';
import 'package:enchere_app/UI/rechargerSolde.dart';
import 'package:enchere_app/UI/retirerSolde.dart';
import 'package:enchere_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée trouvée.'));
        }

        final userData = snapshot.data!;
        int score = userData["score"];
        String solde = userData["solde"];
        String image = userData["image"];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              children: [
                // === Profile  ===
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String newImageUrl = await uploadImage(image);
                        await editUserData("image", newImageUrl);

                        setState(() {
                          _userDataFuture = getAllUserData();
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData['Nom']} ${userData['Prénom']}',
                            style: const TextStyle(fontSize: 24),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Score : ",
                                style: TextStyle(fontSize: 20),
                              ),
                              getTextForScore(score),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // === Solde  ===
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 217, 217, 217),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Votre solde : $solde MAD",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => rechargerSolde(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Colors.white,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromARGB(255, 0, 132, 162),
                              ),
                              fixedSize: const WidgetStatePropertyAll(
                                Size(160, 40),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: const Text("Recharger solde"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => retirerSolde(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromARGB(255, 0, 132, 162),
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Colors.white,
                              ),
                              fixedSize: const WidgetStatePropertyAll(
                                Size(160, 40),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: const Text("Retirer solde"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // === Notification  ===
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      const Color.fromRGBO(217, 217, 217, 1),
                    ),
                    iconColor: WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.notifications_outlined, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 130),
                      Icon(Icons.arrow_right_sharp, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // === Données personnelles ===
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: "Nom",
                        data: userData["Nom"] ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: "Prénom",
                        data: userData["Prénom"] ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: "Date de naissance",
                        data: userData["Date de naissance"] ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: "Pays",
                        data: userData["Pays"] ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: "Adresse",
                        data: userData["Adresse"] ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: DataField(
                        label: 'numéros de téléphone',
                        data: userData["numéros de téléphone"] ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // === Déconnexion ===
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      const Color.fromRGBO(217, 217, 217, 1),
                    ),
                    iconColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 255, 0, 0),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.logout_outlined, size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Déconnexion",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 0, 0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DataField extends StatefulWidget {
  final String label;
  final String data;

  const DataField({Key? key, required this.label, required this.data})
    : super(key: key);

  @override
  _DataFieldState createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  bool isEditable = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromRGBO(217, 217, 217, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(widget.label, style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: isEditable,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 16),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (isEditable) {
                await editUserData(widget.label, _controller.text);
              }
              setState(() {
                isEditable = !isEditable;
              });
            },
            icon: Icon(isEditable ? Icons.check : Icons.edit),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

Text getTextForScore(int score) {
  if (score >= 0 && score < 800) {
    return Text(
      '$score (Mauvais)',
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 207, 2, 2)),
    );
  } else if (score >= 800 && score < 1000) {
    return Text(
      '$score (Moyenne)',
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 231, 164, 8)),
    );
  } else if (score >= 1000 && score < 1200) {
    return Text(
      '$score (Bien)',
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 2, 207, 57)),
    );
  } else if (score >= 1200) {
    return Text(
      '$score (Très Bien)',
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 3, 142, 40)),
    );
  } else {
    return Text('');
  }
}
