import 'package:flutter/material.dart';

class WoundResultScreen extends StatelessWidget {
  const WoundResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EFE8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analysis Result",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildSeverityCard(),
            const SizedBox(height: 18),
            _buildSuppliesCard(),
            const SizedBox(height: 18),
            _buildStepsCard(),
            const SizedBox(height: 18),
            _buildVetWarningCard(),
            const SizedBox(height: 22),
            _buildAnalyzeAgainButton(context),
          ],
        ),
      ),
    );
  }

  // 🔴 SEVERITY CARD
  Widget _buildSeverityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2EE),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFF8A65)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF7043),
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            "See Vet Soon",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFF7043),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Two open wounds on a dog's front paw/leg with raw tissue, redness, and missing fur. The wounds appear relatively fresh with exposed dermis and signs of inflammation around the edges. The pad appears dark/discolored which may indicate bruising.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5F7D6E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 🧴 SUPPLIES CARD
  Widget _buildSuppliesCard() {
    final supplies = [
      "Saline solution or clean lukewarm water",
      "Sterile gauze pads (non-stick)",
      "Pet-safe antibiotic ointment",
      "Vet wrap or medical tape",
      "E-collar to prevent licking",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB7D6C6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SUPPLIES NEEDED",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Color(0xFF2F6B4F),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: supplies.map((e) => _chip(e)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEFE5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 16, color: Color(0xFF2F6B4F)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2F6B4F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🩺 STEPS CARD
  Widget _buildStepsCard() {
    final steps = [
      "Gently clean the wounds with lukewarm water or saline solution to remove debris - do not scrub",
      "Pat dry with clean gauze and apply a thin layer of pet-safe antibiotic ointment if available",
      "Cover with a non-stick pad and wrap with gauze/bandage to keep clean - prevent licking with an e-collar if needed",
      "Monitor closely for signs of infection and keep the paw dry and clean until veterinary evaluation",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB7D6C6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FIRST AID STEPS",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Color(0xFF2F6B4F),
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(
              steps.length,
              (i) => _stepItem(i + 1, steps[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEFE5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2F6B4F)),
            ),
            child: Text(
              "$number",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F6B4F),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2F6B4F),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟠 WHEN TO GO TO VET CARD
  Widget _buildVetWarningCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          decoration: BoxDecoration(
            color: const Color(0xFFE9E0CC),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFFE4BE57),
              width: 1.3,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF5B12),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "WHEN TO GO TO VET",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: Color(0xFFEF5B12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                "Increased swelling, pus or discharge, foul odor, spreading redness, limping worsens, fever, lethargy, or wounds don't show improvement within 24-48 hours",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFFD25A21),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // left dog ear
        Positioned(
          top: -6,
          left: 24,
          child: Container(
            width: 38,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFF0C742),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),

        // right dog ear
        Positioned(
          top: -6,
          right: 24,
          child: Container(
            width: 38,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFF0C742),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📷 Analyze another wound button
  Widget _buildAnalyzeAgainButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.camera_alt_outlined,
          color: Color(0xFF102027),
        ),
        label: const Text(
          "Analyze Another Wound",
          style: TextStyle(
            color: Color(0xFF102027),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF7F7F7),
          side: const BorderSide(
            color: Color(0xFFA6D7B3),
            width: 1.7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}