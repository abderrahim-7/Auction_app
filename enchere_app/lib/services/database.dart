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
      'solde': 0,
      'score': 1000,
      'image': "userData['Prénom']",
    });
  }
}

Future<Map<String, dynamic>> getUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return <String, dynamic>{};

  final userID = user.uid;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(userID).get();
  Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
  return data;
}

Future<void> editUserData(String label, String Value) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await userDoc.set({label: Value}, SetOptions(merge: true));
}

Future<List<Map<String, dynamic>>> getEncheresData() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Enchere").get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print("Erreur lors du chargement des enchères: $e");
    return [];
  }
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
) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("Utilisateur non connecté.");
      return;
    }

    await FirebaseFirestore.instance.collection('Enchere').add({
      'Produit': nom,
      'Description': description,
      'Adresse': Adresse,
      'Mode': Mode,
      'Prix': Prix,
      'Image': imagePrincipale,
      'imagesSecondaires': imagesSecondaires,
      'Temps restant': time,
      'Propriétaire': currentUser.uid,
      'MeilleurEnchérisseur': null,
    });

    print("Enchère créée avec succès !");
  } catch (e) {
    print("Erreur lors de la création de l'enchère : $e");
  }
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
