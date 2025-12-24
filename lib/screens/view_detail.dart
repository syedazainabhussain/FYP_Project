import 'package:flutter/material.dart';

/// Static UI for mechanic detail view.
///
/// This file contains a simple MechanicDetailScreen widget that shows a
/// mechanic avatar, name, rating, distance, online/offline status tag, a
/// call action (placeholder) and a square map placeholder at the bottom.
///
/// The UI is structured so it can be wired easily to a backend API later.

class Mechanic {
  final String id;
  final String name;
  final String avatarUrl; // can be network url in future
  final double rating; // 0-5
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
  const MechanicDetailScreen({Key? key, required this.mechanic, this.serviceType = ''}) : super(key: key);

  // Contract (2-3 bullets):
  // - input: Mechanic model
  // - output: purely visual; call button shows placeholder (will call phone/tel later)
  // - error modes: missing avatar uses initials; missing phone disables call

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Trying a Poppins-like font family if available in project assets.
    const String uiFont = 'Poppins';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(context),
                    const SizedBox(width: 12),
                    // Use Flexible to avoid overflow on small screens
                    Flexible(child: _buildMechanicInfo(context, textTheme, uiFont)),
                    const SizedBox(width: 8),
                    // Move call button to bottom; show status only here
                    _buildStatusTag(),
                  ],
                ),
              ),

              // Divider
              const Divider(height: 1),

              // Additional details row (rating, distance) and experience tag below
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildRatingChip(),
                        const SizedBox(width: 12),
                        _buildDistanceTile(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Experience shown as a tag near the distance (bottom of the details block)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${mechanic.experienceYears} yrs experience', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Map placeholder (square) with full thumbnail background
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Stack(
                        children: [
                          // Full thumbnail as background for the map placeholder
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/m1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // subtle overlay to make icons readable
                          Positioned.fill(
                            child: Container(color: Colors.black.withOpacity(0.06)),
                          ),
                          // center map icon but smaller to avoid overflow
                          Center(child: Icon(Icons.map_outlined, size: 56, color: Colors.white.withOpacity(0.9))),
                          // Small location thumbnail (static) at the top-right of the map placeholder.
                          
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.my_location, size: 18, color: Colors.blueAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Mechanic is at near ${mechanic.distanceKm.toStringAsFixed(1)} km — tap for directions',
                                      style: TextStyle(fontFamily: uiFont, fontSize: 13),
                                    ),
                                  ),
                                  const Icon(Icons.directions, color: Colors.blueAccent),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Full width call button shown after map
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: mechanic.phone.trim().isNotEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Would open call to ${mechanic.phone}')));
                          }
                        : null,
                    icon: const Icon(Icons.phone),
                    label: const Text('Call Mechanic'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Small note / placeholder for future actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'This is a static preview. In production the call button will open the phone dialer and the map will show live directions to the mechanic.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: uiFont, fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    // If you have a real avatar url, use Image.network with placeholder/fallback
    return CircleAvatar(
      radius: 36,
     // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      // Use a static local asset as a fallback profile picture for the static UI.
      backgroundImage: mechanic.avatarUrl.isNotEmpty
          ? NetworkImage(mechanic.avatarUrl)
          : const AssetImage('assets/images/car.jpg') as ImageProvider,
    );
  }

  Widget _buildMechanicInfo(BuildContext context, TextTheme textTheme, String uiFont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mechanic.name,
          style: TextStyle(fontFamily: uiFont, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.work_outline, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 6),
            Text('Mobile Mechanic', style: TextStyle(fontFamily: uiFont, fontSize: 13, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16, color: Colors.redAccent),
            const SizedBox(width: 6),
            Text('${mechanic.distanceKm.toStringAsFixed(1)} km away', style: TextStyle(fontFamily: uiFont, fontSize: 13, color: Colors.grey.shade700)),
          ],
        ),
      ],
    );
  }

  

  Widget _buildRatingChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: Colors.orange),
          const SizedBox(width: 6),
          Text(mechanic.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDistanceTile() {
    return Row(
      children: [
        const Icon(Icons.place_outlined, size: 16, color: Colors.blueAccent),
        const SizedBox(width: 6),
        Text('${mechanic.distanceKm.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusTag() {
    final color = mechanic.isOnline ? Colors.green.shade600 : Colors.grey.shade600;
    final text = mechanic.isOnline ? 'Online' : 'Offline';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.14)),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// A small helper builder for quick preview. You can remove this in production.
class MechanicDetailPreview extends StatelessWidget {
  const MechanicDetailPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mechanic = const Mechanic(
      id: 'm1',
      name: 'Alex Johnson',
      avatarUrl: '',
      rating: 4.8,
      distanceKm: 2.6,
      isOnline: true,
      phone: '+1234567890',
      lat: 37.4219983,
      lng: -122.084,
    );

    return MechanicDetailScreen(mechanic: mechanic, serviceType: '',);
  }
}