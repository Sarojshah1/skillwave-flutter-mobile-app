import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

import 'info_row.dart';

class PersonalInfo extends StatelessWidget {
  final UserEntity user;

  const PersonalInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InfoRow(icon: Icons.email_outlined, label: "Email", value: user.email),
        InfoRow(icon: Icons.person_outline, label: "Role", value: user.role),
        InfoRow(icon: Icons.calendar_today_outlined, label: "Joined", value: DateFormat('MMM dd, yyyy').format(user.createdAt)),
        const SizedBox(height: 16),
        const Text("Bio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(user.bio, ),
      ],
    );
  }
}