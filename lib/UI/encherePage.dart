import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enchere_app/UI/Root.dart';
import 'package:enchere_app/services/countdown.dart';
import 'package:enchere_app/services/database.dart';
import 'package:enchere_app/services/notificationLogic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Encherepage extends StatefulWidget {
  final String enchereId;
  final bool isOwner;

  const Encherepage({
    super.key,
    required this.enchereId,
    required this.isOwner,
  });

  @override
  State<Encherepage> createState() => _EncherepageState();
}

class _EncherepageState extends State<Encherepage> {
  TextEditingController montantController = TextEditingController();
  Map<String, dynamic>? enchereData;
  bool isLoading = true;
  bool isAuctionEnded = false;

  @override
  void initState() {
    super.initState();
    _fetchEnchere();
  }

  Future<void> _fetchEnchere() async {
    final data = await getEnchereById(widget.enchereId);
    setState(() {
      enchereData = data;
      isLoading = false;
    });
  }

  Future<Map<String, dynamic>> getDetails(
    String currentUserId,
    String? ownerId,
    String? winnerId,
  ) async {
    String message = '';
    String? name;
    String? address;
    String? phone;

    final bool hasWinner = winnerId != null && winnerId.isNotEmpty;

    if (!hasWinner && widget.isOwner) {
      message = "Cette enchère a échoué";
    } else if (widget.isOwner && hasWinner) {
      final firstName = await getUserData(winnerId!, "Prénom");
      final lastName = await getUserData(winnerId, "Nom");
      name = "$firstName $lastName";
      message = "L'utilisateur $name a gagné l'enchère";
      address = await getUserData(winnerId, "Adresse");
      phone = await getUserData(winnerId, "numéros de téléphone");
    } else if (!widget.isOwner && winnerId != currentUserId) {
      message = "Cette enchère est terminée";
    } else if (!widget.isOwner && winnerId == currentUserId) {
      message = "Vous avez gagné cette enchère";
      final firstName = await getUserData(ownerId!, "Prénom");
      final lastName = await getUserData(ownerId, "Nom");
      name = "$firstName $lastName";
      address = await getUserData(ownerId, "Adresse");
      phone = await getUserData(ownerId, "numéros de téléphone");
    }

    return {
      'message': message,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 132, 162),
        title: const Center(
          child: Text("Enchère", style: TextStyle(color: Colors.white)),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 132, 162),
                ),
              )
              : Stack(
                children: [
                  AbsorbPointer(
                    absorbing: isAuctionEnded,
                    child: Center(
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (enchereData != null &&
                              enchereData!['Temps restant'] != null)
                            CountdownTimer(
                              endTime: DateTime.fromMillisecondsSinceEpoch(
                                enchereData!['Temps restant'],
                              ),
                              fontSize: 30,
                              enchereId: widget.enchereId,
                              onAuctionExpired: () {
                                setState(() {
                                  isAuctionEnded = true;
                                });
                              },
                            ),
                          Container(
                            width: 200,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(enchereData?["Image"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            enchereData?["Produit"],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 13,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 50, 154, 54),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              enchereData?["Prix"] + " MAD",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Enrichisseur actuel : ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      enchereData?["ImageEnrichisseur"],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FutureBuilder<String>(
                                  future: getFullName(
                                    enchereData?["enchérisseur"],
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                        "Chargement...",
                                        style: TextStyle(fontSize: 18),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                        "Aucun",
                                        style: TextStyle(fontSize: 18),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data ?? "",
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              readOnly: widget.isOwner,
                              controller: montantController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    widget.isOwner
                                        ? const Color.fromARGB(
                                          154,
                                          178,
                                          173,
                                          173,
                                        )
                                        : Colors.white,
                                hintText: 'Entrer le montant',
                                hintStyle: TextStyle(
                                  color:
                                      widget.isOwner
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color:
                                        widget.isOwner
                                            ? Colors.black
                                            : const Color.fromARGB(
                                              255,
                                              0,
                                              132,
                                              162,
                                            ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color:
                                        widget.isOwner
                                            ? Colors.black
                                            : const Color.fromARGB(
                                              255,
                                              0,
                                              132,
                                              162,
                                            ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed:
                                widget.isOwner ||
                                        FirebaseAuth
                                                .instance
                                                .currentUser
                                                ?.uid ==
                                            enchereData?["enchérisseur"]
                                    ? null
                                    : () async {
                                      int? montant = int.tryParse(
                                        montantController.text,
                                      );
                                      if (montant == null) {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Veuillez entrer un nombre valide.",
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                        );
                                        return;
                                      }
                                      int prix = int.parse(
                                        enchereData?["Prix"] ?? "0",
                                      );
                                      if (montant <= prix) {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Montant inférieur au prix actuel",
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                        );
                                      } else {
                                        final user =
                                            FirebaseAuth.instance.currentUser;

                                        if (user != null) {
                                          String rawSolde =
                                              await getUserData(
                                                user.uid,
                                                "solde",
                                              ) ??
                                              "0";
                                          int solde = int.parse(rawSolde);

                                          if (solde < montant) {
                                            Fluttertoast.showToast(
                                              msg: "solde insuffisant",
                                              backgroundColor: Colors.black54,
                                              textColor: Colors.white,
                                            );
                                          } else {
                                            // NEW: refund previous bidder
                                            String? oldBidderId =
                                                enchereData?["enchérisseur"];
                                            int oldPrix =
                                                int.tryParse(
                                                  enchereData?["Prix"] ?? "0",
                                                ) ??
                                                0;

                                            if (oldBidderId != null &&
                                                oldBidderId != user.uid) {
                                              String rawOldSolde =
                                                  await getUserData(
                                                    oldBidderId,
                                                    "solde",
                                                  ) ??
                                                  "0";
                                              int oldSolde =
                                                  int.tryParse(rawOldSolde) ??
                                                  0;

                                              int oldbiddersolde =
                                                  oldSolde + oldPrix;
                                              await editUserDataById(
                                                oldBidderId,
                                                "solde",
                                                oldbiddersolde.toString(),
                                              );
                                            }

                                            // Deduct from new bidder
                                            int newBidderSolde =
                                                solde - montant;
                                            await editUserData(
                                              "solde",
                                              newBidderSolde.toString(),
                                            );

                                            // Continue updating other data
                                            String prenom =
                                                await getUserData(
                                                  user.uid,
                                                  "Prénom",
                                                ) ??
                                                "";
                                            String nom =
                                                await getUserData(
                                                  user.uid,
                                                  "Nom",
                                                ) ??
                                                "";
                                            String username = prenom + nom;
                                            String enrichisseur = user.uid;
                                            String image =
                                                await getUserData(
                                                  user.uid,
                                                  "image",
                                                ) ??
                                                "";
                                            final auctionTitle =
                                                enchereData?["Produit"];

                                            // Notify previous bidder
                                            if (oldBidderId != null &&
                                                oldBidderId != user.uid) {
                                              NotificationService.addNotification(
                                                oldBidderId,
                                                title: 'Enchère dépassée',
                                                description:
                                                    'Vous avez été dépassé sur "$auctionTitle".',
                                                type: 'outbid',
                                                auctionId: enchereData?["id"],
                                              );
                                            }

                                            await editEnchereData(
                                              enchereData?["id"],
                                              "enchérisseur",
                                              enrichisseur,
                                            );
                                            await editEnchereData(
                                              enchereData?["id"],
                                              "ImageEnrichisseur",
                                              image,
                                            );
                                            await editEnchereData(
                                              widget.enchereId,
                                              "Prix",
                                              montant.toString(),
                                            );

                                            if (enchereData?["mode"] ==
                                                "En ligne") {
                                              DateTime newEndTime =
                                                  DateTime.now().add(
                                                    const Duration(minutes: 2),
                                                  );
                                              await editEnchereData(
                                                enchereData?["id"],
                                                "endTime",
                                                Timestamp.fromDate(newEndTime),
                                              );
                                            }

                                            montantController.clear();
                                            await _fetchEnchere();

                                            Fluttertoast.showToast(
                                              msg:
                                                  "Montant mis à jour avec succès.",
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                            );

                                            addEnchereToUser(
                                              enchereData?["id"],
                                            );

                                            await NotificationService.addNotification(
                                              enchereData?["Vendeur"],
                                              title: 'Nouvelle enchère',
                                              description:
                                                  'Votre article "$auctionTitle" a reçu une nouvelle offre.',
                                              type: 'bid_received',
                                              auctionId: enchereData?["id"],
                                            );
                                          }
                                        }
                                      }
                                    },
                            style: ButtonStyle(
                              backgroundColor:
                                  widget.isOwner ||
                                          FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  ?.uid ==
                                              enchereData?["enchérisseur"]
                                      ? const WidgetStatePropertyAll(
                                        Colors.blueGrey,
                                      )
                                      : const WidgetStatePropertyAll(
                                        Color.fromARGB(255, 0, 132, 162),
                                      ),
                              elevation: const WidgetStatePropertyAll(0),
                            ),
                            child: const Text(
                              "Surenchérir",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isAuctionEnded)
                    FutureBuilder<User?>(
                      future: FirebaseAuth.instance.authStateChanges().first,
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData)
                          return const SizedBox.shrink();

                        final currentUserId = userSnapshot.data!.uid;
                        final ownerId = enchereData?['Vendeur'];
                        final winnerId = enchereData?['enchérisseur'];

                        return FutureBuilder<Map<String, dynamic>>(
                          future: getDetails(currentUserId, ownerId, winnerId),
                          builder: (context, detailsSnapshot) {
                            if (!detailsSnapshot.hasData)
                              return const CircularProgressIndicator();

                            final details = detailsSnapshot.data!;
                            final message = details['message'] as String;
                            final name = details['name'] as String;
                            final address = details['address'] as String?;
                            final phone =
                                details['numéros de téléphone'] as String?;

                            return Container(
                              color: Colors.black.withOpacity(0.7),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      message,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    if (name != null) ...[
                                      Text(
                                        "Nom: $name",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Adresse: $address",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Téléphone: $phone",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                    ElevatedButton(
                                      onPressed: () async {
                                        if ((winnerId == null ||
                                                winnerId.isEmpty) &&
                                            widget.isOwner) {
                                          await deleteEnchere(widget.enchereId);
                                        }
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Root(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text("Retour à l'accueil"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: const Color.fromARGB(255, 0, 132, 162),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Root()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white, size: 37),
            ),
            const Text(
              "Quitter",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
