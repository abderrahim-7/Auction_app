import 'package:enchere_app/UI/encherePage.dart';
import 'package:enchere_app/UI/rechargerSolde.dart';
import 'package:enchere_app/services/countdown.dart';
import 'package:enchere_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Enchereinfos extends StatefulWidget {
  final String enchereId;
  final bool isOwner;

  const Enchereinfos({
    super.key,
    required this.enchereId,
    required this.isOwner,
  });

  @override
  State<Enchereinfos> createState() => _EnchereinfosState();
}

class _EnchereinfosState extends State<Enchereinfos> {
  Map<String, dynamic>? enchereData;
  bool isLoading = true;

  List<String> images = [];
  int _selectedImage = 0;

  @override
  void initState() {
    super.initState();
    fetchEnchere();
  }

  Future<void> fetchEnchere() async {
    final data = await getEnchereById(widget.enchereId);
    setState(() {
      enchereData = data;
      final List<String> secondaries = List<String>.from(
        data?["imagesSecondaires"] ?? [],
      );
      images = [data?["Image"], ...secondaries];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (enchereData == null) {
      return const Scaffold(body: Center(child: Text("Enchère introuvable")));
    }

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
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[_selectedImage],
                  height: 200,
                  width: 170,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _selectedImage == index
                                  ? Colors.blue
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images[index],
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),

            Table(
              columnWidths: const {0: IntrinsicColumnWidth()},
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                // Produit
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Produit :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Text(enchereData?['Produit'] ?? ''),
                    ),
                  ],
                ),

                // Description
                TableRow(
                  children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Description :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: Text(enchereData?['Description'] ?? ''),
                    ),
                  ],
                ),

                // Catégories
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Catégories :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        (enchereData?['catégories'] as List<dynamic>?)?.join(
                              ', ',
                            ) ??
                            'Aucune',
                      ),
                    ),
                  ],
                ),

                // Vendeur
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Vendeur :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: FutureBuilder<String>(
                        future: getUserData(
                          enchereData?['Vendeur'],
                          "Prénom",
                        ).then(
                          (prenom) => getUserData(
                            enchereData?['Vendeur'],
                            "Nom",
                          ).then((label) => "$prenom $label"),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Erreur de chargement");
                          } else {
                            return Text(snapshot.data ?? "");
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Adresse
                TableRow(
                  children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Adresse :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: Text(enchereData?['Adresse'] ?? ''),
                    ),
                  ],
                ),

                // Mode
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Mode :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Text(enchereData?['Mode'] ?? ''),
                    ),
                  ],
                ),

                // Temps restant
                TableRow(
                  children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Temps restant :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(8),
                      child: CountdownTimer(
                        endTime: DateTime.fromMillisecondsSinceEpoch(
                          enchereData?['Temps restant'] ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),

                // Prix actuel
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Prix actuel :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Text("${enchereData?['Prix']} MAD"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => rechargerSolde()),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    side: MaterialStatePropertyAll(
                      const BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 1.5,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Recharger",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 132, 162),
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prixRaw = enchereData?['Prix'] ?? 0;
                    double prix = double.tryParse(prixRaw.toString()) ?? 0;
                    final String userId =
                        FirebaseAuth.instance.currentUser!.uid;

                    final soldeRaw = await getUserData(userId, 'solde');
                    double solde = double.tryParse(soldeRaw.toString()) ?? 0;
                    if (solde <= prix) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Solde insuffisant"),
                              content: const Text(
                                "Votre solde est insuffisant pour rejoindre cette enchère.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Encherepage(
                                enchereId: enchereData?["id"],
                                isOwner: false,
                              ),
                        ),
                      );
                    }
                  },

                  style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(
                      const Color.fromARGB(255, 0, 132, 162),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Rejoindre",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
