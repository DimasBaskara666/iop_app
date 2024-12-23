import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool switchControl;
  final bool switchValue; // Tambahkan properti untuk nilai switch
  final ValueChanged<bool>?
      onSwitchChanged; // Callback untuk perubahan nilai switch
  final VoidCallback? onTap;

  const ControlCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.switchControl = false,
    this.switchValue = false,
    this.onSwitchChanged, // Callback baru untuk switch
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: Colors.orangeAccent),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
            if (switchControl)
              Switch(
                value: switchValue, // Gunakan switchValue untuk nilai
                activeColor: Colors.orangeAccent,
                onChanged: onSwitchChanged, // Callback perubahan switch
              ),
          ],
        ),
      ),
    );
  }
}
