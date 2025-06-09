import 'package:flutter/material.dart';
import 'package:enchere_app/services/notificationLogic.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Future<List<Map<String, dynamic>>> notificationsData;

  @override
  void initState() {
    super.initState();
    notificationsData = NotificationService.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: notificationsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucune notification'));
            } else {
              return ListView(children: notificationsList(snapshot.data!));
            }
          },
        ),
      ),
    );
  }

  Widget notificationWidget(
    String id,
    String title,
    String description,
    String date,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () async {
                  await NotificationService.deleteNotification(id);
                  setState(() {
                    notificationsData = NotificationService.getNotifications();
                  });
                },
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> notificationsList(List<Map<String, dynamic>> notificationsData) {
    List<Widget> widgets = [];

    for (var notification in notificationsData) {
      final timestamp = notification["timestamp"];
      String dateStr = "";
      String timeStr = "";

      if (timestamp != null) {
        DateTime dateTime;
        if (timestamp is DateTime) {
          dateTime = timestamp;
        } else if (timestamp is Map && timestamp['_seconds'] != null) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(
            timestamp['_seconds'] * 1000,
          );
        } else if (timestamp is int) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        } else {
          dateTime = DateTime.now();
        }

        dateStr =
            "${dateTime.day.toString().padLeft(2, '0')}/"
            "${dateTime.month.toString().padLeft(2, '0')}/"
            "${dateTime.year}";
        timeStr =
            "${dateTime.hour.toString().padLeft(2, '0')}:"
            "${dateTime.minute.toString().padLeft(2, '0')}";
      }

      widgets.add(
        notificationWidget(
          notification['id'] ?? '',
          notification["title"] ?? "Sans titre",
          notification["description"] ?? "",
          dateStr,
          timeStr,
        ),
      );
    }

    return widgets;
  }
}
