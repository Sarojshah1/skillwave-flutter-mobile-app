import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactCard extends StatelessWidget {
  final Map<String, dynamic> info;

  const ContactCard(this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: List<Color>.from(info['gradient'])),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Icon(info['icon'], color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info['title'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ...List.generate((info['details'] as List).length, (i) {
                    return Text(info['details'][i], style: const TextStyle(color: Colors.grey));
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}