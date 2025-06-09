import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<void> createUserDocument(
  String Nom,
  String Prenom,
  String DateNaissance,
  String Pays,
  String Adresse,
  String numTel,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  final docSnapshot = await userDoc.get();
  if (!docSnapshot.exists) {
    await userDoc.set({
      'Nom': Nom,
      'Prénom': Prenom,
      'Date de naissance': DateNaissance,
      'Pays': Pays,
      'Adresse': Adresse,
      'numéros de téléphone': numTel,
      'solde': "0",
      'score': 1000,
      'image': "https://i.ibb.co/0RBbM0s9/profil-Image.png",
      'Encheres': [],
    });
  }
}

Future<Map<String, dynamic>> getAllUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return <String, dynamic>{};

  final userID = user.uid;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(userID).get();
  Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
  return data;
}

Future<void> editUserData(String label, dynamic Value) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await userDoc.set({label: Value}, SetOptions(merge: true));
}

Future<void> editUserDataById(
  String userId,
  String label,
  dynamic value,
) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

  await userDoc.set({label: value}, SetOptions(merge: true));
}

Future<dynamic> getUserData(String id, String label) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(id).get();
  Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
  return data[label];
}

Future<List<Map<String, dynamic>>> getEncheresData({
  required bool ended,
  bool? isParticipant,
  bool? isOwner,
}) async {
  try {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("Enchere")
            .where("ended", isEqualTo: ended)
            .get();

    List<Map<String, dynamic>> filtered = [];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      if (isOwner == true && data['Vendeur'] != currentUserId) {
        continue;
      }

      if (isParticipant == true) {
        bool participant = await isUserParticipant(doc.id);
        if (!participant) continue;
      }

      filtered.add(data);
    }

    return filtered;
  } catch (e) {
    print("Erreur lors du chargement des enchères: $e");
    return [];
  }
}

Future<Map<String, dynamic>?> getEnchereById(String id) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Enchere').doc(id).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    } else {
      return null;
    }
  } catch (e) {
    print("Erreur lors de la récupération de l'enchère: $e");
    return null;
  }
}

Future<String> getFullName(String userId) async {
  String prenom = await getUserData(userId, "Prénom");
  String nom = await getUserData(userId, "Nom");
  return "$prenom $nom";
}

Future<void> createEnchereData(
  String nom,
  String description,
  String Adresse,
  String Mode,
  String Prix,
  String imagePrincipale,
  List<String> imagesSecondaires,
  String time,
  List<String> categories,
) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("Utilisateur non connecté.");
      return;
    }

    List<String> parts = time.split(" : ");

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    Duration duration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    DateTime now = DateTime.now();

    DateTime endTime = now.add(duration);

    int endTimeMillis = endTime.millisecondsSinceEpoch;

    await FirebaseFirestore.instance.collection('Enchere').add({
      'Produit': nom,
      'Description': description,
      'Adresse': Adresse,
      'Mode': Mode,
      'Prix': Prix,
      'Image': imagePrincipale,
      'imagesSecondaires': imagesSecondaires,
      'Temps restant': endTimeMillis,
      'enchérisseur': "",
      'ImageEnrichisseur': "https://i.ibb.co/tw1wrCvy/images.png",
      'Vendeur': FirebaseAuth.instance.currentUser?.uid,
      'Participants': [],
      'ended': false,
      'state': "",
      'catégories': categories,
    });

    print("Enchère créée avec succès !");
  } catch (e) {
    print("Erreur lors de la création de l'enchère : $e");
  }
}

Future<void> editEnchereData(String id, String label, dynamic Value) async {
  final enchereDoc = FirebaseFirestore.instance.collection('Enchere').doc(id);

  await enchereDoc.set({label: Value}, SetOptions(merge: true));
}

Future<void> deleteEnchere(String id) async {
  try {
    await FirebaseFirestore.instance.collection('Enchere').doc(id).delete();

    print('Document deleted successfully!');
  } catch (e) {
    print('Error deleting document: $e');
  }
}

Future<void> addEnchereToUser(String idEnchere) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final enchere = await getEnchereById(idEnchere);
  if (enchere == null) return;

  final List<dynamic> participants = enchere["Participants"] ?? [];
  final List<dynamic> encheres = (await getUserData(userId, 'Encheres')) ?? [];

  if (!participants.contains(userId)) {
    participants.add(userId);
    encheres.add(idEnchere);

    await editEnchereData(idEnchere, "Participants", participants);
    await editUserData("Encheres", encheres);
  }
}

Future<bool> isUserParticipant(String idEnchere) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return false;

  final enchere = await getEnchereById(idEnchere);
  if (enchere == null) return false;

  final List<dynamic> participants = enchere["Participants"] ?? [];
  return participants.contains(userId);
}

Future<String> uploadImage(String current) async {
  try {
    // Pick image from gallery
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      // User canceled
      return current;
    }

    // Convert to File
    File imageFile = File(pickedImage.path);

    // Convert to base64
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Upload to imgbb
    final response = await http.post(
      Uri.parse(
        "https://api.imgbb.com/1/upload?key=83f09c9375407d2cd879091446e29306",
      ),
      body: {'image': base64Image},
    );

    //get the image url
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['url'];
    } else {
      print('Upload failed: ${response.body}');
      return current;
    }
  } catch (e) {
    print('Error during image upload: $e');
    return current;
  }
}
