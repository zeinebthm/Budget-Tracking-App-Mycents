import 'package:flutter/material.dart';
import 'package:budgetapp_fl/common/color_extension.dart';

class SettingsBar extends StatefulWidget {
  const SettingsBar({super.key});

  @override
  State<SettingsBar> createState() => _SettingsBarState();
}

class _SettingsBarState extends State<SettingsBar> {
  String _userName = "Issa Samir Ibrahiim";
  String _currency = "EUR";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.gray70.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColor.border.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Einstellungen",
            style: TextStyle(
              color: TColor.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsRow(
            icon: Icons.person,
            label: "Name: $_userName",
            onTap: () {
              _showEditDialog("Name", _userName, (newValue) {
                setState(() {
                  _userName = newValue;
                });
              });
            },
          ),
          _buildSettingsRow(
            icon: Icons.attach_money,
            label: "Währung: $_currency",
            onTap: () {
              _showEditDialog("Währung", _currency, (newValue) {
                setState(() {
                  _currency = newValue;
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: TColor.white),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(color: TColor.white))),
            Icon(Icons.chevron_right, color: TColor.gray30),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String title, String initialValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColor.gray70,
          title: Text(
            "$title ändern",
            style: TextStyle(color: TColor.white),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: TColor.white),
            decoration: InputDecoration(
              hintText: "$title eingeben",
              hintStyle: TextStyle(color: TColor.gray30),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TColor.gray30),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TColor.primary10),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Abbrechen", style: TextStyle(color: TColor.gray30)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary10,
              ),
              child: Text("Speichern"),
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
