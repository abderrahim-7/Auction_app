import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static Future<void> addNotification(
    String userId, {
    required String title,
    required String description,
    required String type,
    String? auctionId,
  }) async {
    final notification = {
      'title': title,
      'description': description,
      'type': type,
      'timestamp': Timestamp.now(),
      'auctionId': auctionId ?? '',
      'isRead': false,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add(notification);
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }

      final notifSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .get();

      final notifications =
          notifSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  static Future<void> deleteNotification(String notificationId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
