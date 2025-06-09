import 'package:enchere_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enchere_app/services/notificationLogic.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;
  final double fontSize;
  final String enchereId;
  final VoidCallback? onAuctionExpired;

  const CountdownTimer({
    super.key,
    required this.endTime,
    this.fontSize = 18,
    this.enchereId = "",
    this.onAuctionExpired,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remaining;
  late final ticker;
  bool _hasHandledExpiration = false;

  @override
  void initState() {
    super.initState();
    remaining = widget.endTime.difference(DateTime.now());

    ticker = Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = widget.endTime.difference(now);
      return diff.inSeconds > 0 ? diff : Duration.zero;
    }).listen((duration) async {
      if (mounted) {
        setState(() {
          remaining = duration;
        });

        if (duration == Duration.zero && !_hasHandledExpiration) {
          _hasHandledExpiration = true;

          // Mark auction as ended
          await editEnchereData(widget.enchereId, "ended", true);

          // Fetch latest auction data
          final enchereData = await getEnchereById(widget.enchereId);
          final encherisseur = enchereData?['enchérisseur'] ?? "";

          if (encherisseur == "") {
            await deleteEnchere(widget.enchereId);
            final auctionTitle = enchereData?["Produit"];
            await NotificationService.addNotification(
              enchereData?["Vendeur"],
              title: 'Aucune enchère',
              description:
                  'Votre enchère "$auctionTitle" est terminée sans acheteur.',
              type: 'auction_ended_no_buyer',
              auctionId: enchereData?["id"],
            );
          } else {
            final auctionTitle = enchereData?["Produit"];
            final winnerName = enchereData?["enchérisseur"];
            await NotificationService.addNotification(
              enchereData?["Vendeur"],
              title: 'Vente réussie',
              description:
                  'Votre article "$auctionTitle" a été vendu à $winnerName.',
              type: 'auction_sold',
              auctionId: widget.enchereId,
            );
            final Participants = enchereData?["Participants"];
            for (var participant in Participants) {
              await NotificationService.addNotification(
                participant,
                title: 'Fin de l’enchère',
                description:
                    participant == enchereData?["enchérisseur"]
                        ? 'Félicitations ! Vous avez gagné l’enchère "$auctionTitle".'
                        : 'L’enchère "$auctionTitle" est terminée. Vous n’avez pas gagné.',
                type: 'auction_ended',
                auctionId: enchereData?["id"],
              );
            }
            final state = enchereData?["state"];
            if (state == "") {
              await editEnchereData(
                widget.enchereId,
                "state",
                "en attent de livraison",
              );
              await editEnchereData(
                widget.enchereId,
                "stateLastUpdated",
                FieldValue.serverTimestamp(),
              );
            }
          }

          if (widget.onAuctionExpired != null) {
            widget.onAuctionExpired!();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    return Text(
      "$hours:$minutes:$seconds",
      style: TextStyle(fontSize: widget.fontSize, color: Colors.black),
    );
  }
}
