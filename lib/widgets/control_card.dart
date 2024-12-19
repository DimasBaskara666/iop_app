import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool switchControl;
  final VoidCallback? onTap;

  const ControlCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.switchControl = false,
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
                value: subtitle.toLowerCase() == 'on' || subtitle.toLowerCase() == 'locked',
                onChanged: (value) {
                  if (onTap != null) onTap!();
                },
              ),
          ],
        ),
      ),
    );
  }
}
