import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Screens imports
import 'mechanic_bookingrequest.dart';
import 'mechanic_earnings.dart';
import 'mechanic_profile.dart';
import 'mechanic_login.dart';
import 'mechanic_settings.dart'; 
import '../authentication/user_session.dart';
import '../homescreen.dart';
import '../verify_screen.dart'; 

class MechanicDashboardScreen extends StatefulWidget {
  const MechanicDashboardScreen({super.key});

  static List<Map<String, dynamic>> acceptedRequests = [];
  static List<Map<String, dynamic>> rejectedRequests = [];

  @override
  State<MechanicDashboardScreen> createState() =>
      _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState extends State<MechanicDashboardScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  List<Map<String, dynamic>> requests = [
    {
      'user': 'Ali Khan',
      'service': 'Car Mechanic',
      'status': 'Pending',
      'distance': 2.5,
      'earnings': 1200,
      'timer': 60,
      'timer_started': false,
    },
    {
      'user': 'Sarah Ahmed',
      'service': 'Car Mechanic',
      'status': 'Pending',
      'distance': 3.2,
      'earnings': 800,
      'timer': 45,
      'timer_started': false,
    },
  ];

  double totalEarnings = 3500.0;
  double todaysEarnings = 2000.0;
  double mechanicRating = 4.8;
  String mechanicName = "Aslam Rashid";

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final url = Uri.parse("https://mechanicapp-service-621632382478.asia-south1.run.app/api/mechanic/dashboard");
    try {
      final response = await http.get(url, headers: UserSession().getAuthHeader());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data['mechanic'] != null) {
            mechanicName = data['mechanic']['name'] ?? mechanicName;
            mechanicRating = (data['mechanic']['averagerating'] as num?)?.toDouble() ?? mechanicRating;
          }
          if (data['earnings'] != null) {
            totalEarnings = (data['earnings']['total'] as num?)?.toDouble() ?? totalEarnings;
            todaysEarnings = (data['earnings']['today'] as num?)?.toDouble() ?? todaysEarnings;
          }
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: primaryColor, size: 28),
            onPressed: _openNotifications,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.settings, color: primaryColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MechanicSettingsScreen(
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onThemeChanged: (val) {},
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 25),
            _buildEarningsCard(),
            const SizedBox(height: 30),
            Text('Quick Actions', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 15),
            Row(
              children: [
                _actionCard('Requests', Icons.pending_actions, Colors.blue, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicBookingRequestScreen()));
                }),
                const SizedBox(width: 15),
                _actionCard('My Wallet', Icons.account_balance_wallet, Colors.green, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicEarningsScreen()));
                }),
              ],
            ),
            const SizedBox(height: 30),
            Text('Active requests', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 15),
            _buildRecentJobsList(isDark),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildProfileHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, $mechanicName', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('$mechanicRating Rating', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        CircleAvatar(radius: 30, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, color: Color(0xFFFB3300), size: 35)),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, const Color(0xFFFF6A00)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Total Earnings', totalEarnings),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem("Today's Profit", todaysEarnings),
        ],
      ),
    );
  }

  Widget _buildRecentJobsList(bool isDark) {
    if (requests.isEmpty) {
      return Center(child: Text("No jobs found", style: GoogleFonts.poppins(color: Colors.grey)));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (context, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _jobTile(requests[index], isDark),
    );
  }

  Widget _statItem(String label, double val) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
        Text('Rs. ${val.toStringAsFixed(0)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobTile(Map<String, dynamic> r, bool isDark) {
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.orange[900] : const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.timer_outlined, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['user'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                Text(r['service'], style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Rs. ${r['earnings']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryColor)),
              Text('${r['timer']}s left', style: GoogleFonts.poppins(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void _openNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          for (int i = 0; i < requests.length; i++) {
            if (requests[i]['timer_started'] == false) {
              requests[i]['timer_started'] = true;
              Timer.periodic(const Duration(seconds: 1), (timer) {
                if (!context.mounted) {
                  timer.cancel();
                  return;
                }
                if (requests[i]['timer'] > 0) {
                  setModalState(() { requests[i]['timer']--; });
                } else {
                  timer.cancel();
                  setModalState(() {
                    var expired = requests.removeAt(i);
                    MechanicDashboardScreen.rejectedRequests.add(expired);
                  });
                  setState(() {});
                }
              });
            }
          }

          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Text('New Service Requests', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Expanded(
                  child: requests.isEmpty 
                  ? Center(child: Text("No new requests", style: GoogleFonts.poppins()))
                  : ListView.separated(
                    itemCount: requests.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      var r = requests[index];
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r['user'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text('${r['timer']}s', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(r['service'], style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        r['status'] = 'Accepted';
                                        MechanicDashboardScreen.acceptedRequests.add(r);
                                        requests.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicBookingRequestScreen()));
                                    },
                                    child: const Text('Accept'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        MechanicDashboardScreen.rejectedRequests.add(r);
                                        requests.removeAt(index);
                                      });
                                      setModalState(() {});
                                    },
                                    child: const Text('Reject'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Drawer _buildDrawer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDark ? Colors.black : Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: isDark ? Colors.black : Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : const Color(0xFFFFEDE9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.build_rounded, color: primaryColor, size: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mechanic Panel',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard_rounded, 'Dashboard', color: primaryColor, onTap: () => Navigator.pop(context)),
          _drawerItem(Icons.calendar_month_rounded, 'Booking Requests', color: primaryColor, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicBookingRequestScreen()));
          }),
          _drawerItem(Icons.account_balance_wallet_rounded, 'Earnings', color: primaryColor, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicEarningsScreen()));
          }),
          _drawerItem(Icons.person_outline_rounded, 'Profile', color: primaryColor, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicProfileScreen()));
          }),
          const Divider(color: Colors.grey),
          _drawerItem(Icons.settings_outlined, 'Settings', color: primaryColor, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => MechanicSettingsScreen(
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              onThemeChanged: (val) {},
            )));
          }),
          _drawerItem(Icons.logout_rounded, 'Logout', color: Colors.red, onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MechanicLoginScreen()),
              (route) => false,
            );
          }),
          _buildSwitchModeButton(),
        ],
      ),
    );
  }

  Widget _buildSwitchModeButton() {
    // ignore: unused_local_variable
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () async {
          if (await UserSession().trySwitchTo('USER')) {
            if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
          } else {
            if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const VerifyScreen()), (r) => false);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.swap_horiz_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text('Switch to User Mode', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: color ?? primaryColor),
      title: Text(title, style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500, fontSize: 15)),
      onTap: onTap,
    );
  }
}
