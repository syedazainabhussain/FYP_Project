import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicBookingRequestScreen extends StatefulWidget {
  const MechanicBookingRequestScreen({super.key});

  @override
  State<MechanicBookingRequestScreen> createState() =>
      _MechanicBookingRequestScreenState();
}

class _MechanicBookingRequestScreenState
    extends State<MechanicBookingRequestScreen>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFB3300);

  TabController? _tabController;

  /// 🔴 Pending Booking Requests
  List<Map<String, dynamic>> bookingRequests = [
    {
      'userName': 'Ali Khan',
      'mobile': '0301-1234567',
      'address': 'Johar Town, Lahore',
      'service': 'Bike Repair',
      'problem': 'Bike start nahi ho rahi',
      'date': '12 Jan 2026',
      'time': '4:30 PM',
      'amount': 1200,
      'status': 'Pending',
    },
    {
      'userName': 'Sarah Ahmed',
      'mobile': '0305-9876543',
      'address': 'Gulshan-e-Iqbal, Karachi',
      'service': 'Car Mechanic',
      'problem': 'Engine overheating',
      'date': '13 Jan 2026',
      'time': '11:00 AM',
      'amount': 2500,
      'status': 'Pending',
    },
  ];

  /// 🟢 Booking History
  List<Map<String, dynamic>> bookingHistory = [
    {
      'userName': 'Usman Ali',
      'address': 'DHA Phase 6, Lahore',
      'service': 'Car Battery Change',
      'date': '08 Jan 2026',
      'time': '2:00 PM',
      'amount': 3000,
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Bookings',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: _tabController != null
            ? TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: subTextColor,
                indicatorColor: primaryColor,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Requests'),
                  Tab(text: 'History'),
                ],
              )
            : null,
      ),
      body: _tabController != null
          ? TabBarView(
              controller: _tabController,
              children: [
                _requestsTab(cardColor, textColor, subTextColor, shadowColor),
                _historyTab(cardColor, textColor, subTextColor, shadowColor),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  /// ================= REQUESTS TAB =================
  Widget _requestsTab(Color cardColor, Color textColor, Color subTextColor, Color shadowColor) {
    if (bookingRequests.isEmpty) {
      return _emptyView('No booking requests', subTextColor);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookingRequests.length,
      itemBuilder: (context, index) {
        final r = bookingRequests[index];
        return _requestCard(r, index, cardColor, textColor, shadowColor);
      },
    );
  }

  Widget _requestCard(Map<String, dynamic> r, int index, Color cardColor, Color textColor, Color shadowColor) {
    return _cardContainer(
      cardColor: cardColor,
      shadowColor: shadowColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleRow(r['userName'], r['status'], textColor: textColor),
          const SizedBox(height: 6),
          _infoRow(Icons.phone, r['mobile'], textColor: textColor),
          _infoRow(Icons.location_on, r['address'], textColor: textColor),
          const Divider(),
          _infoRow(Icons.build, r['service'], textColor: textColor),
          _infoRow(Icons.description, r['problem'], textColor: textColor),
          const Divider(),
          _infoRow(Icons.calendar_today, '${r['date']} • ${r['time']}', textColor: textColor),
          _infoRow(Icons.attach_money, 'PKR ${r['amount']}', textColor: textColor),
          const SizedBox(height: 10),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    bookingRequests.removeAt(index);
                  });
                },
                child: const Text('Reject', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    r['status'] = 'Completed';
                    bookingHistory.insert(0, r);
                    bookingRequests.removeAt(index);
                  });
                },
                child: const Text('Accept'),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ================= HISTORY TAB =================
  Widget _historyTab(Color cardColor, Color textColor, Color subTextColor, Color shadowColor) {
    if (bookingHistory.isEmpty) {
      return _emptyView('No booking history', subTextColor);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookingHistory.length,
      itemBuilder: (context, index) {
        final h = bookingHistory[index];
        return _cardContainer(
          cardColor: cardColor,
          shadowColor: shadowColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleRow(h['userName'], h['status'], textColor: textColor),
              const SizedBox(height: 6),
              _infoRow(Icons.location_on, h['address'], textColor: textColor),
              const Divider(),
              _infoRow(Icons.build, h['service'], textColor: textColor),
              _infoRow(Icons.calendar_today, '${h['date']} • ${h['time']}', textColor: textColor),
              _infoRow(Icons.attach_money, 'PKR ${h['amount']}', textColor: textColor),
            ],
          ),
        );
      },
    );
  }

  /// ================= REUSABLE WIDGETS =================
  Widget _cardContainer({required Widget child, required Color cardColor, required Color shadowColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 8),
        ],
      ),
      child: child,
    );
  }

  Widget _titleRow(String title, String status, {Color? textColor}) {
    Color color = status == 'Completed' ? Colors.green : primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: textColor ?? Colors.black87),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, color: textColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyView(String text, Color subTextColor) {
    return Center(
      child: Text(text, style: GoogleFonts.poppins(fontSize: 16, color: subTextColor)),
    );
  }
}
