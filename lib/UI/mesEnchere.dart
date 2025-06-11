import 'package:enchere_app/UI/enchereWidget.dart';
import 'package:flutter/material.dart';

class MesEncheres extends StatefulWidget {
  const MesEncheres({super.key});

  @override
  State<MesEncheres> createState() => _MesEncheresState();
}

class _MesEncheresState extends State<MesEncheres> {
  bool isOngoingSelected = true;
  bool showOngoingGrid1 = false;
  bool showOngoingGrid2 = false;
  bool showFinishedGrid1 = false;
  bool showFinishedGrid2 = false;

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 200, 200, 200),
              ),
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 200, 200, 200),
            ),
            child: Row(
              children: [
                // "En cours" tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isOngoingSelected = true),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isOngoingSelected
                                ? Colors.white
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "En cours",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // "Terminé" tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isOngoingSelected = false),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            !isOngoingSelected
                                ? Colors.white
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Terminé",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child:
              isOngoingSelected
                  ? _buildOngoingContent()
                  : _buildFinishedContent(),
        ),
      ],
    );
  }

  Widget _buildOngoingContent() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => showOngoingGrid1 = !showOngoingGrid1),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Créer par vous"),
                Icon(showOngoingGrid1 ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (showOngoingGrid1)
          Expanded(
            child: EncheresList(
              ended: false,
              isParticipant: false,
              isOwner: true,
              onDataChanged: _refresh,
            ),
          ),
        GestureDetector(
          onTap: () => setState(() => showOngoingGrid2 = !showOngoingGrid2),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vos participations"),
                Icon(showOngoingGrid2 ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (showOngoingGrid2)
          Expanded(
            child: EncheresList(
              ended: false,
              isParticipant: true,
              isOwner: false,
              onDataChanged: _refresh,
            ),
          ),
      ],
    );
  }

  Widget _buildFinishedContent() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => showFinishedGrid1 = !showFinishedGrid1),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Créer par vous"),
                Icon(showFinishedGrid1 ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (showFinishedGrid1)
          Expanded(
            child: EncheresList(
              ended: true,
              isParticipant: false,
              isOwner: true,
              onDataChanged: _refresh,
              aspectRatio: 0.6,
            ),
          ),
        GestureDetector(
          onTap: () => setState(() => showFinishedGrid2 = !showFinishedGrid2),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vos participations"),
                Icon(showFinishedGrid2 ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (showFinishedGrid2)
          Expanded(
            child: EncheresList(
              ended: true,
              isParticipant: true,
              isOwner: false,
              onDataChanged: _refresh,
              aspectRatio: 0.65,
            ),
          ),
      ],
    );
  }
}
