import 'package:flutter/material.dart';
import 'package:mech_app/screens/view_detail.dart';
import 'mechanic_list_screen.dart';
import 'auto_assign.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Color primaryColor = const Color(0xFFFB3300);

  final List<Map<String, dynamic>> nearbyMechanics = [
    {
      "id": 1,
      "name": "Ali Mechanic",
      "rating": 4.8,
      "distance": 2.5,
      "available": true,
      "image": "assets/images/m1.jpg",
      "phone": "03001234567",
    },
    {
      "id": 2,
      "name": "Ahmed Auto Repair",
      "rating": 4.6,
      "distance": 4.0,
      "available": false,
      "image": "assets/images/m2.png",
      "phone": "03009876543",
    },
    {
      "id": 3,
      "name": "Zain's Garage",
      "rating": 4.7,
      "distance": 3.2,
      "available": true,
      "image": "assets/images/m3.jpg",
      "phone": "03001112233",
    },
    {
      "id": 4,
      "name": "John Auto",
      "rating": 4.5,
      "distance": 5.0,
      "available": true,
      "image": "assets/images/m4.png",
      "phone": "03004445566",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi 👋", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              "Syeda Zainab",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auto-Assign Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [primaryColor, Colors.deepOrange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Need a Mechanic Now?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Nearest mechanic will be auto assigned",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AutoAssignScreen(),
                        ),
                      );
                    },
                    child: const Text("Auto Assign Mechanic"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            // Nearby Mechanics Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nearby Mechanics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160, // reduced height for smart look
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyMechanics.length,
                itemBuilder: (context, index) {
                  return _NearbyMechanicCompactCard(
                    mechanic: nearbyMechanics[index],
                    primaryColor: primaryColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Service Categories
            const Text(
              "Service Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _serviceCard(context, "Bike Mechanic", 'assets/images/bike.jpg'),
            const SizedBox(height: 16),
            _serviceCard(context, "Car Mechanic", 'assets/images/car.jpg'),
            const SizedBox(height: 16),
            _serviceCard(context, "Puncher", 'assets/images/puncherr.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(BuildContext context, String title, String image) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MechanicListScreen(serviceType: title),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  "Syeda Zainab",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyMechanicCompactCard extends StatelessWidget {
  final Map<String, dynamic> mechanic;
  final Color primaryColor;

  const _NearbyMechanicCompactCard({
    required this.mechanic,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // slightly smaller width
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mechanic info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(mechanic['image']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mechanic['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text("${mechanic['rating']}"),
                        const SizedBox(width: 10),
                        Icon(Icons.location_on,
                            size: 14, color: primaryColor),
                        Text("${mechanic['distance']} km"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mechanic['available'] ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton(
                  icon: Icons.call,
                  label: "Call",
                  color: Colors.green,
                  onTap: () {
                    // Implement call functionality
                  }),
    _actionButton(
    icon: Icons.remove_red_eye,
    label: "View",
    color: primaryColor,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MechanicDetailScreen(
            serviceType: "View Mechanic",
            mechanic: Mechanic(
              id: mechanic['id'].toString(),
              name: mechanic['name'] ?? '',
              avatarUrl: mechanic['image'] ?? '',
              rating: (mechanic['rating'] is int)
                  ? (mechanic['rating'] as int).toDouble()
                  : (mechanic['rating'] as double? ?? 0.0),
              distanceKm: (mechanic['distance'] is int)
                  ? (mechanic['distance'] as int).toDouble()
                  : (mechanic['distance'] as double? ?? 0.0),
              isOnline: mechanic['available'] ?? false,
              phone: mechanic['phone'] ?? '',
              lat: (mechanic['lat'] is num) ? (mechanic['lat'] as num).toDouble() : 0.0,
              lng: (mechanic['lng'] is num) ? (mechanic['lng'] as num).toDouble() : 0.0,
            ),
          ),
        ),
      );
    }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}