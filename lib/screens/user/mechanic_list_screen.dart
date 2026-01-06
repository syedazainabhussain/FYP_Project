import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'view_detail.dart';

class MechanicListScreen extends StatelessWidget {
  final String serviceType;
  final List<Map<String, dynamic>> mechanics;

  const MechanicListScreen({
    super.key,
    required this.serviceType,
    required this.mechanics,
  });

  final Color primaryColor = const Color(0xFFFB3300);

  @override
  Widget build(BuildContext context) {
    // Detect current brightness
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final bgColor = isDark ? Colors.grey[900] : Colors.grey.shade100;
    final cardColor = (isDark ? Colors.grey[850] : Colors.white) ?? Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nearby Mechanics",
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(serviceType,
                style: TextStyle(fontSize: 13, color: subtitleColor)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mechanics.length,
        itemBuilder: (context, index) {
          return _NearbyMechanicCardVertical(
            mechanic: mechanics[index],
            primaryColor: primaryColor,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
          );
        },
      ),
    );
  }
}

class _NearbyMechanicCardVertical extends StatelessWidget {
  final Map<String, dynamic> mechanic;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _NearbyMechanicCardVertical({
    required this.mechanic,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: mechanic['image'].toString().startsWith('http')
                    ? NetworkImage(mechanic['image'])
                    : AssetImage(mechanic['image']) as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mechanic['name'],
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: textColor)),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text("${mechanic['rating']}",
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: subtitleColor)),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on, size: 14, color: primaryColor),
                        Text("${mechanic['distance']} km",
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: subtitleColor)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: mechanic['available'] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton(
                Icons.call_rounded,
                "Call",
                Colors.green,
                () async {
                  final phone = mechanic['phone'] as String?;
                  if (phone != null && phone.isNotEmpty) {
                    final Uri launchUri = Uri(scheme: 'tel', path: phone);
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch dialer for $phone')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phone number not available')));
                  }
                },
              ),
              _actionButton(
                Icons.remove_red_eye_rounded,
                "View",
                primaryColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MechanicDetailScreen(
                        serviceType: "View Mechanic",
                        mechanic: Mechanic(
                          id: mechanic['id'].toString(),
                          name: mechanic['name'],
                          avatarUrl: mechanic['image'],
                          rating: (mechanic['rating'] as num).toDouble(),
                          distanceKm: (mechanic['distance'] as num).toDouble(),
                          isOnline: mechanic['available'],
                          phone: mechanic['phone'],
                          lat: 0.0,
                          lng: 0.0,
                          experienceYears: mechanic['experience'] ?? 0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.poppins(
                    color: color, fontWeight: FontWeight.w500, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
