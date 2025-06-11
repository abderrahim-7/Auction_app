import 'package:enchere_app/UI/createEnchere.dart';
import 'package:enchere_app/UI/enchereInfos.dart';
import 'package:enchere_app/UI/encherePage.dart';
import 'package:enchere_app/services/countdown.dart';
import 'package:enchere_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategorie = 'Catégorie';
  String selectedPrix = 'Prix';
  String selectedDate = 'Date de fin';

  final List<String> categories = [
    'Catégorie',
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
  final List<String> prix = [
    'Prix',
    '0-100 MAD',
    '100-500 MAD',
    '500-1000 MAD',
    '1000-2500 MAD',
    '2500-5000 MAD',
    '+5000 MAD',
  ];
  final List<String> dates = [
    "Date de fin",
    '0-4 h',
    '4-12 h',
    '1 jour',
    '7 jours',
    '14 jours',
    '1 mois',
    '+1 mois',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // === Search Bar ===
        Container(
          height: 150,
          decoration: BoxDecoration(color: Color.fromARGB(255, 0, 132, 162)),
          alignment: Alignment(0, 0.65),
          child: Container(
            width: 370,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Chercher un enchère',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 132, 162),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 132, 162),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),

        // === Filter Row ===
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(color: Color.fromARGB(255, 212, 209, 209)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_alt_outlined),
                  Text("Filtrer :", style: TextStyle(fontSize: 14)),
                ],
              ),
              FilterOptions(
                value: selectedCategorie,
                items: categories,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategorie = newValue;
                  });
                },
              ),
              FilterOptions(
                value: selectedPrix,
                items: prix,
                onChanged: (newValue) {
                  setState(() {
                    selectedPrix = newValue;
                  });
                },
              ),
              FilterOptions(
                value: selectedDate,
                items: dates,
                onChanged: (newValue) {
                  setState(() {
                    selectedDate = newValue;
                  });
                },
              ),
            ],
          ),
        ),

        // === Scrollable Enchère List ===
        Expanded(
          child: FutureBuilder<List<Widget>>(
            future: createEncheres(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune enchère trouvée.'));
              } else {
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  children: snapshot.data!,
                );
              }
            },
          ),
        ),

        // === Create Enchère ===
        Container(
          height: 40,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                spreadRadius: 20.0,
                offset: const Offset(0.0, 3.0),
              ),
            ],
          ),
          child: Container(
            height: 35,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateEnchere()),
                );
              },
              style: ButtonStyle(
                elevation: WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Color.fromARGB(255, 0, 132, 162),
                    width: 3,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: Text(
                "Créer un enchère",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 132, 162),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget FilterOptions({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return IntrinsicWidth(
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: SizedBox(),
          iconSize: 16,
          style: TextStyle(fontSize: 10, color: Colors.black),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 13)),
                );
              }).toList(),
          onChanged: (newValue) {
            onChanged(newValue!);
          },
        ),
      ),
    );
  }

  Widget Enchere(
    String id,
    String mode,
    String productImage,
    String name,
    String price,
    DateTime endTime,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        String currUser = FirebaseAuth.instance.currentUser!.uid;
        final Data = await getEnchereById(id);
        String OwnerId = Data?["Vendeur"];
        if (currUser == OwnerId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Encherepage(enchereId: id, isOwner: true),
            ),
          );
        } else if (await isUserParticipant(id)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Encherepage(enchereId: id, isOwner: false),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Enchereinfos(enchereId: id, isOwner: false),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 231, 231, 231)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mode,
              style: TextStyle(
                fontSize: 18,
                color: mode == "Temps limité" ? Colors.green : Colors.red,
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(name, style: TextStyle(fontSize: 18, color: Colors.black)),
            Text(
              '$price MAD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            CountdownTimer(
              endTime: endTime,
              enchereId: id,
              onAuctionExpired: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> createEncheres(BuildContext context) async {
    List<Map<String, dynamic>> encheres = await getEncheresData(ended: false);
    List<Widget> widgets = [];

    String searchText = searchController.text.toLowerCase();

    for (final enchere in encheres) {
      String name = enchere['Produit'].toString().toLowerCase();
      String prixStr = enchere['Prix'].toString();
      double prix = double.tryParse(prixStr) ?? 0;

      int endTimeMillis = enchere['Temps restant'];
      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
      Duration timeLeft = endTime.difference(DateTime.now());

      List<dynamic> enchereCategories = enchere['catégories'] ?? [];

      // === Filtering by search text ===
      if (searchText.isNotEmpty && !name.contains(searchText)) continue;

      // === Filtering by category ===
      if (selectedCategorie != 'Catégorie' &&
          !enchereCategories.contains(selectedCategorie)) {
        continue;
      }
      // === Filtering by price ===
      if (selectedPrix == '0-100 MAD' && !(prix >= 0 && prix <= 100)) continue;
      if (selectedPrix == '100-500 MAD' && !(prix > 100 && prix <= 500))
        continue;
      if (selectedPrix == '500-1000 MAD' && !(prix > 500 && prix <= 1000))
        continue;
      if (selectedPrix == '1000-2500 MAD' && !(prix > 1000 && prix <= 2500))
        continue;
      if (selectedPrix == '2500-5000 MAD' && !(prix > 2500 && prix <= 5000))
        continue;
      if (selectedPrix == '+5000 MAD' && prix <= 5000) continue;

      // === Filtering by remaining time ===
      if (selectedDate == '0-4 h' && timeLeft > Duration(hours: 4)) continue;
      if (selectedDate == '4-12 h' &&
          (timeLeft <= Duration(hours: 4) || timeLeft > Duration(hours: 12))) {
        continue;
      }
      if (selectedDate == '1 jour' &&
          (timeLeft <= Duration(hours: 12) || timeLeft > Duration(days: 1))) {
        continue;
      }
      if (selectedDate == '7 jours' &&
          (timeLeft <= Duration(days: 1) || timeLeft > Duration(days: 7))) {
        continue;
      }
      if (selectedDate == '14 jours' &&
          (timeLeft <= Duration(days: 7) || timeLeft > Duration(days: 14))) {
        continue;
      }
      if (selectedDate == '1 mois' &&
          (timeLeft <= Duration(days: 14) || timeLeft > Duration(days: 30))) {
        continue;
      }
      if (selectedDate == '+1 mois' && timeLeft <= Duration(days: 30)) {
        continue;
      }

      widgets.add(
        Enchere(
          enchere['id'],
          enchere['Mode'],
          enchere['Image'],
          enchere['Produit'],
          enchere['Prix'],
          endTime,
          context,
        ),
      );
    }

    return widgets;
  }
}
