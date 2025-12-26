import 'package:flutter/material.dart';
import 'auto_assign.dart';

class ServiceChatScreen extends StatefulWidget {
  final String serviceType;

  const ServiceChatScreen({super.key, required this.serviceType});

  @override
  State<ServiceChatScreen> createState() => _ServiceChatScreenState();
}

class _ServiceChatScreenState extends State<ServiceChatScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  String? selectedProblem;
  String? vehicleMoving;
  String urgency = "Normal";
  bool isSubmitting = false;

  final TextEditingController noteController = TextEditingController();

  final Map<String, List<String>> problemOptions = {
    "Car Mechanic": ["Engine Issue", "AC Not Working", "Battery Problem", "Brake Issue"],
    "Bike Mechanic": ["Self Start Problem", "Chain Issue", "Engine Noise"],
    "Puncher": ["Flat Tyre", "Air Leakage", "Rim Issue"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "${widget.serviceType} Assistant",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // Skip action placeholder
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _questionCard("1. Tell us your problem", _customDropdown(
                      value: selectedProblem,
                      hint: "Select problem",
                      items: problemOptions[widget.serviceType]!,
                      onChanged: (value) => setState(() => selectedProblem = value),
                    )),
                    _questionCard("2. Is your vehicle moving?", _yesNoButtons()),
                    _questionCard("3. How urgent is this?", _customDropdown(
                      value: urgency,
                      hint: "Select urgency",
                      items: ["Normal", "Urgent", "Emergency"],
                      onChanged: (value) => setState(() => urgency = value!),
                    )),
                    _questionCard("4. Additional details (optional)", _noteField()),
                    const SizedBox(height: 16),
                    _summaryCard(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _confirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _questionCard(String question, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _customDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _yesNoButtons() {
    return Row(
      children: [
        _choiceButton("Yes"),
        const SizedBox(width: 12),
        _choiceButton("No"),
      ],
    );
  }

  Widget _choiceButton(String value) {
    final bool selected = vehicleMoving == value;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primaryColor : Colors.grey.shade300),
          boxShadow: [
            if (selected)
              BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3))
          ],
        ),
        child: InkWell(
          onTap: () {
            setState(() => vehicleMoving = value);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Type here...",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.orange, thickness: 1.2),
          const SizedBox(height: 6),
          _summaryRow("Service", widget.serviceType),
          _summaryRow("Problem", selectedProblem ?? "-"),
          _summaryRow("Vehicle Moving", vehicleMoving ?? "-"),
          _summaryRow("Urgency", urgency),
          _summaryRow("Notes", noteController.text.isEmpty ? "-" : noteController.text),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isSubmitting
            ? null
            : () async {
                if (selectedProblem == null || vehicleMoving == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please complete required fields")),
                  );
                  return;
                }

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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
