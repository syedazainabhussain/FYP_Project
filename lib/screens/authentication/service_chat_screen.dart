import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auto_assign.dart';
import 'user_session.dart';

class ServiceChatScreen extends StatefulWidget {
  final String serviceType;
  final int id;

  const ServiceChatScreen({
    super.key,
    required this.serviceType,
    required this.id,
  });

  @override
  State<ServiceChatScreen> createState() => _ServiceChatScreenState();
}

class _ServiceChatScreenState extends State<ServiceChatScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  bool isLoading = true;
  bool isSubmitting = false;
  bool isFinished = false;

  List<Map<String, dynamic>> currentOptions = [];
  List<String> selectionPath = [];
  int? lastSelectedId;

  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOptions(widget.id);
  }

  // ================= API CALL =================
  Future<void> fetchOptions(int parentId) async {
    setState(() => isLoading = true);

    final url = Uri.parse(
        "https://mechanicapp-service-621632382478.asia-south1.run.app/api/subproblems/$parentId");

    try {
      final response = await http.get(
        url,
        headers: UserSession().getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          if (data.isEmpty) {
            isFinished = true;
          } else {
            currentOptions = data
                .map((e) => {"id": e["id"], "text": e["text"]})
                .toList();
          }
          isLoading = false;
        });
      } else {
        throw Exception("API Failed");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _handleOptionSelect(Map<String, dynamic> option) {
    setState(() {
      selectionPath.add(option["text"]);
      lastSelectedId = option["id"];
    });
    fetchOptions(option["id"]);
  }

  void _resetSelection() {
    setState(() {
      selectionPath.clear();
      lastSelectedId = null;
      isFinished = false;
    });
    fetchOptions(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: textColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${widget.serviceType} Assistant",
          style: TextStyle(
              color: textColor, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (selectionPath.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh, color: textColor),
              onPressed: _resetSelection,
            )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _questionCard(
              cardColor,
              "Tell us about your problem",
              isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : isFinished
                      ? _welcomeMessage(isDark)
                      : _optionsList(isDark),
            ),

            _questionCard(
              cardColor,
              "Additional details (optional)",
              _noteField(isDark),
            ),

            _summaryCard(isDark),

            const SizedBox(height: 20),

            _confirmButton(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _optionsList(bool isDark) {
    return Column(
      children: currentOptions.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              side: BorderSide(color: Colors.grey.shade400),
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _handleOptionSelect(option),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(option["text"],
                      style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                ),
                Icon(Icons.chevron_right,
                    color: isDark ? Colors.white70 : Colors.grey),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ✅ UPDATED SELECTION COMPLETE (Dark friendly)
  Widget _welcomeMessage(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle,
              color: primaryColor, size: 48),
          const SizedBox(height: 10),
          Text(
            "Selection Complete",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: _resetSelection,
            child: Text(
              "Change Selection",
              style: TextStyle(
                color: isDark ? Colors.white : primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _questionCard(Color cardColor, String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _noteField(bool isDark) {
    return TextField(
      controller: noteController,
      maxLines: 3,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: "Type here...",
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _summaryCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.orange.shade900 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          const Divider(),
          _summaryRow("Service", widget.serviceType),
          if (selectionPath.isNotEmpty)
            _summaryRow("Selection", selectionPath.join(" > ")),
          _summaryRow(
              "Notes", noteController.text.isEmpty ? "-" : noteController.text),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  // ✅ BUTTON ALWAYS ORANGE + WHITE TEXT
  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isSubmitting || (!isFinished && selectionPath.isEmpty)
            ? null
            : () async {
                setState(() => isSubmitting = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => isSubmitting = false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AutoAssignScreen()),
                );
              },
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Confirm & Find Mechanic",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }
}
