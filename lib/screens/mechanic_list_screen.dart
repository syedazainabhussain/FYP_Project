import 'package:flutter/material.dart';

class MechanicListScreen extends StatelessWidget {
  final String serviceType;

  MechanicListScreen({super.key, required this.serviceType});

  final Color primaryColor = const Color(0xFFFB3300);

  final List<Map<String, dynamic>> mechanics = [
    {
      "name": "Ali Mechanic",
      "rating": 4.8,
      "distance": 2.5,
      "available": true,
      "image": "assets/images/m1.jpg",
      "phone": "03001234567",
    },
    {
      "name": "Ahmed Auto Repair",
      "rating": 4.6,
      "distance": 4.0,
      "available": false,
      "image": "assets/images/m2.png",
      "phone": "03009876543",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nearby Mechanics",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(serviceType,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ],
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mechanics.length,
        itemBuilder: (context, index) {
          final m = mechanics[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Image.asset(
                    m['image'],
                    width: 120,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                /// DETAILS
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// NAME + STATUS
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            _statusBadge(m['available']),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// RATING + DISTANCE
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text("${m['rating']}"),
                            const SizedBox(width: 12),
                            Icon(Icons.location_on,
                                size: 16, color: primaryColor),
                            const SizedBox(width: 4),
                            Text("${m['distance']} km"),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// BUTTONS
                        Row(
                          children: [
                            _actionButton(Icons.call, "Call", primaryColor),
                            const SizedBox(width: 10),
                            _actionButton(
                                Icons.visibility, "View", Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: available
            ? Colors.green.withOpacity(0.12)
            : Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? "Available" : "Busy",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: available ? Colors.green : Colors.red),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label,
                style:
                    TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
