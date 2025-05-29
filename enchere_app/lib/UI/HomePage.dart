import 'package:enchere_app/UI/createEnchere.dart';
import 'package:enchere_app/UI/enchereInfos.dart';
import 'package:enchere_app/services/database.dart';
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

  final List<String> categories = ['Catégorie', 'Art', 'Gaming'];
  final List<String> prix = ['Prix', '0-100 MAD', '100-500 MAD', '+500 MAD'];
  final List<String> dates = [
    'Date de fin',
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
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
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),

        // === Filter Row ===
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Color.fromARGB(255, 212, 209, 209)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_alt_outlined),
                  Text("Filtrer :", style: TextStyle(fontSize: 16)),
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
          style: TextStyle(fontSize: 14, color: Colors.black),
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
    String mode,
    String productImage,
    String name,
    String Price,
    String Time,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Enchereinfos()),
        );
      },
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 231, 231, 231)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mode, style: TextStyle(fontSize: 18, color: Colors.green)),
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
              '$Price MAD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(Time, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> createEncheres(BuildContext context) async {
    List<Map<String, dynamic>> encheres = await getEncheresData();
    List<Widget> widgets = [];

    for (int i = 0; i < encheres.length; i++) {
      final enchere = encheres[i];
      widgets.add(
        Enchere(
          enchere['Mode'],
          enchere['Image'],
          enchere['Produit'],
          enchere['Prix'],
          enchere['Temps restant'],
          context,
        ),
      );
    }

    return widgets;
  }
}

Widget FilterOptions({
  required String value,
  required List<String> items,
  required Function(String) onChanged,
}) {
  return IntrinsicWidth(
    child: Container(
      height: 20,
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
        style: TextStyle(fontSize: 12, color: Colors.black),
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 12)),
              );
            }).toList(),
        onChanged: (newValue) {
          onChanged(newValue!);
        },
      ),
    ),
  );
}
