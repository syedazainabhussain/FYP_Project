import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Mechanic {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final double distanceKm;
  final bool isOnline;
  final String phone;
  final double lat;
  final double lng;
  final int experienceYears;

  const Mechanic({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.distanceKm,
    required this.isOnline,
    required this.phone,
    required this.lat,
    required this.lng,
    this.experienceYears = 5,
  });
}

class MechanicDetailScreen extends StatelessWidget {
  final Mechanic mechanic;
  final String serviceType;

  const MechanicDetailScreen({
    super.key,
    required this.mechanic,
    this.serviceType = '',
  });

  final Color primaryColor = const Color(0xFFFB3300); // Deep Orange
  final String uiFont = 'Poppins';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Mechanic Details',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar + Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _buildMechanicInfo(textColor, subTextColor),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusTag(),
                  ],
                ),
              ),

              Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey),

              /// Rating / Distance / Experience
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildRatingChip(),
                        const SizedBox(width: 12),
                        _buildDistanceTile(textColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildExperienceTag(),
                  ],
                ),
              ),

              /// Map
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: cardColor,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/m1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(color: Colors.black.withOpacity(0.15)),
                          ),
                          Center(
                            child: Icon(
                              Icons.map_outlined,
                              size: 56,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Call Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: mechanic.phone.trim().isEmpty
                        ? null
                        : () async {
                            final uri = Uri(
                              scheme: 'tel',
                              path: mechanic.phone,
                            );
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Call Mechanic',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Request Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request sent to mechanic')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Request Mechanic',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widgets

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 36,
      backgroundImage: mechanic.avatarUrl.isNotEmpty
          ? AssetImage(mechanic.avatarUrl)
          : const AssetImage('assets/images/car.jpg'),
    );
  }

  Widget _buildMechanicInfo(Color text, Color subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mechanic.name,
          style: TextStyle(
            fontFamily: uiFont,
            fontSize: 17,
            color: text,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.work_outline, size: 16),
            const SizedBox(width: 6),
            Text(
              'Mobile Mechanic',
              style: TextStyle(fontSize: 13, color: subText),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16),
            const SizedBox(width: 6),
            Text(
              '${mechanic.distanceKm.toStringAsFixed(1)} km away',
              style: TextStyle(fontSize: 13, color: subText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingChip() {
    return Chip(
      backgroundColor: primaryColor.withOpacity(0.15),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            mechanic.rating.toStringAsFixed(1),
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceTile(Color text) {
    return Row(
      children: [
        Icon(Icons.place_outlined, size: 16, color: primaryColor),
        const SizedBox(width: 6),
        Text(
          '${mechanic.distanceKm.toStringAsFixed(1)} km',
          style: TextStyle(color: text),
        ),
      ],
    );
  }

  Widget _buildStatusTag() {
    final color = mechanic.isOnline ? Colors.green : Colors.grey;
    return Chip(
      backgroundColor: color.withOpacity(0.15),
      label: Text(
        mechanic.isOnline ? 'Online' : 'Offline',
        style: TextStyle(color: color),
      ),
    );
  }

  Widget _buildExperienceTag() {
    return Chip(
      backgroundColor: primaryColor.withOpacity(0.15),
      label: Text(
        '${mechanic.experienceYears} yrs experience',
        style: TextStyle(color: primaryColor),
      ),
    );
  }
}
