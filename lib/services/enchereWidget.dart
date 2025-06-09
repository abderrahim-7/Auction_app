import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enchere_app/services/database.dart';
import 'package:enchere_app/services/countdown.dart';
import 'package:enchere_app/UI/enchereInfos.dart';
import 'package:enchere_app/UI/encherePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EncheresList extends StatelessWidget {
  final Function()? onDataChanged;
  final bool ended;
  final bool isOwner;
  final bool isParticipant;
  final double aspectRatio;

  const EncheresList({
    super.key,
    this.onDataChanged,
    this.ended = false,
    this.isOwner = false,
    this.isParticipant = false,
    this.aspectRatio = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _createEncheres(context),
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
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            children: snapshot.data!,
          );
        }
      },
    );
  }

  Future<List<Widget>> _createEncheres(BuildContext context) async {
    List<Map<String, dynamic>> encheres = await getEncheresData(
      ended: ended,
      isOwner: isOwner,
      isParticipant: isParticipant,
    );
    List<Widget> widgets = [];
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    for (final enchere in encheres) {
      int endTimeMillis = enchere['Temps restant'];
      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);

      widgets.add(_buildEnchereCard(enchere, endTime, context, currentUserId));
    }
    return widgets;
  }

  Widget _buildEnchereCard(
    Map<String, dynamic> enchere,
    DateTime endTime,
    BuildContext context,
    String currentUserId,
  ) {
    final String id = enchere['id'];
    final String mode = enchere['Mode'];
    final String productImage = enchere['Image'];
    final String name = enchere['Produit'];
    final String price = enchere['Prix'];
    final String ownerId = enchere['Vendeur'];
    final String encherisseurId = enchere['enchérisseur'] ?? "";
    final String state = enchere['state'] ?? "";

    Widget stateWidget = SizedBox.shrink();

    void onLivreClicked() async {
      await editEnchereData(id, "state", "en attent de reception");
      await editEnchereData(
        id,
        "stateLastUpdated",
        FieldValue.serverTimestamp(),
      );
      if (onDataChanged != null) onDataChanged!();
    }

    void onRecuClicked() async {
      await editEnchereData(id, "state", "Terminé");
      await editEnchereData(
        id,
        "stateLastUpdated",
        FieldValue.serverTimestamp(),
      );
      String vendeurSolde = await getUserData(ownerId, "solde");
      int vSolde = int.parse(vendeurSolde);
      final nouveauSolde = vSolde + int.parse(price);
      await editUserDataById(ownerId, "solde", nouveauSolde.toString());
      if (onDataChanged != null) onDataChanged!();
    }

    if (ended) {
      switch (state) {
        case "en attent de livraison":
          if (currentUserId == ownerId) {
            stateWidget = ElevatedButton(
              onPressed: onLivreClicked,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                side: WidgetStatePropertyAll(BorderSide(color: Colors.green)),
              ),
              child: const Text(
                "Livré",
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            );
          } else if (currentUserId == encherisseurId) {
            stateWidget = const Text(
              "En attente de livraison",
              style: TextStyle(color: Colors.green),
            );
          }
          break;

        case "en attent de reception":
          if (currentUserId == ownerId) {
            stateWidget = const Text("En attente de réception");
          } else if (currentUserId == encherisseurId) {
            stateWidget = ElevatedButton(
              onPressed: onRecuClicked,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                side: WidgetStatePropertyAll(BorderSide(color: Colors.green)),
              ),
              child: const Text(
                "Reçu",
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            );
          }
          break;

        case "Terminé":
          stateWidget = const Text("Terminé");
          break;

        case "Erreur":
          stateWidget = const Text("Erreur - veuillez contacter le support");
          break;

        default:
          stateWidget = const Text("Enchère terminée");
      }
    }

    return GestureDetector(
      onTap: () async {
        if (currentUserId == ownerId) {
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 231, 231),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mode,
              style: const TextStyle(fontSize: 18, color: Colors.green),
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
            Text(
              name,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            Text(
              '$price MAD',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            ended
                ? stateWidget
                : CountdownTimer(
                  endTime: endTime,
                  enchereId: id,
                  onAuctionExpired: onDataChanged ?? () {},
                ),
          ],
        ),
      ),
    );
  }
}
