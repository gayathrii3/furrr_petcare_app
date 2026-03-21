import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';

class PetService {
  final String name;
  final double rating;
  final String price;
  final String location;
  final String bio;
  final String type; // Pet Shop, Dog Trainer, Caretaker, Walker
  final String phone;

  const PetService({
    required this.name,
    required this.rating,
    required this.location,
    required this.price,
    required this.bio,
    required this.type,
    required this.phone,
  });
}

class FindWalkerScreen extends StatefulWidget {
  const FindWalkerScreen({super.key});

  @override
  State<FindWalkerScreen> createState() => _FindWalkerScreenState();
}

class _FindWalkerScreenState extends State<FindWalkerScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    PetProfileService().removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  final List<PetService> _services = const [
    PetService(
      name: "Rahul's K9 Training",
      rating: 4.9,
      location: "Jubilee Hills",
      price: "₹500/session",
      bio: "Professional dog trainer specializing in obedience and behavior correction.",
      type: "Dog Trainer",
      phone: "+91 98765 43210",
    ),
    PetService(
      name: "Paws & Play Shop",
      rating: 4.7,
      location: "Gachibowli",
      price: "Store",
      bio: "Your one-stop shop for premium pet food, toys, and accessories.",
      type: "Pet Shop",
      phone: "+91 87654 32109",
    ),
    PetService(
      name: "Happy Tails Caretaker",
      rating: 4.8,
      location: "Banjara Hills",
      price: "₹800/day",
      bio: "Home-away-from-home boarding service. We treat them like family!",
      type: "Caretaker",
      phone: "+91 76543 21098",
    ),
    PetService(
      name: "Smart Pets Store",
      rating: 4.6,
      location: "Madhapur",
      price: "Store",
      bio: "Modern pet store with a wide range of organic treats and supplements.",
      type: "Pet Shop",
      phone: "+91 65432 10987",
    ),
    PetService(
      name: "Elite Dog Training",
      rating: 4.8,
      location: "Kondapur",
      price: "₹600/session",
      bio: "Advanced agility and protection training for all breeds.",
      type: "Dog Trainer",
      phone: "+91 54321 09876",
    ),
    PetService(
      name: "Comfort Pet Stay",
      rating: 4.5,
      location: "Kukatpally",
      price: "₹700/day",
      bio: "Spacious daycare and overnight boarding with 24/7 supervision.",
      type: "Caretaker",
      phone: "+91 43210 98765",
    ),
    PetService(
      name: "HITEC Pet World",
      rating: 4.9,
      location: "HITEC City",
      price: "Store",
      bio: "High-tech pet accessories and luxury grooming supplies.",
      type: "Pet Shop",
      phone: "+91 32109 87654",
    ),
    PetService(
      name: "Secunderabad Pet Hub",
      rating: 4.4,
      location: "Secunderabad",
      price: "₹300/walk",
      bio: "Reliable dog walking and light training services.",
      type: "Walker",
      phone: "+91 21098 76543",
    ),
    PetService(
      name: "Jubilee Pet Boarding",
      rating: 4.7,
      location: "Jubilee Hills",
      price: "₹1000/day",
      bio: "Luxury boarding with climate-controlled rooms and play areas.",
      type: "Caretaker",
      phone: "+91 10987 65432",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF5),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  final profileLocation = PetProfileService().currentPet.location;
                  
                  if (!service.location.contains(profileLocation)) {
                    return const SizedBox.shrink();
                  }
                  
                  return _buildServiceCard(context, service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 15),
          Text(
            TranslationService.t('pet_services'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B2A22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, PetService service) {
    IconData typeIcon;
    switch (service.type) {
      case "Pet Shop": typeIcon = Icons.shopping_basket_outlined; break;
      case "Dog Trainer": typeIcon = Icons.psychology_outlined; break;
      case "Caretaker": typeIcon = Icons.home_outlined; break;
      default: typeIcon = Icons.pets;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F7C8C).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFD7F2F4),
                child: Icon(typeIcon, color: const Color(0xFF0F7C8C), size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B2A22),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F7C8C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            service.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F7C8C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF476555),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, color: Color(0xFF0F7C8C), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          service.location,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF5F8B73)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                service.price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F7C8C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            service.bio,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF476555),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Calling ${service.name} at ${service.phone}...")),
                );
              },
              icon: const Icon(Icons.phone_outlined, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F7C8C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              label: const Text(
                "Call Now",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
