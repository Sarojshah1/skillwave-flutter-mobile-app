import 'package:flutter/material.dart';
import 'package:skillwave/features/SettingScreen/data/model/stat.dart';


class StatsGrid extends StatelessWidget {
  final List<Stat> stats;

  const StatsGrid({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: stats.map((stat) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(stat.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(stat.number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(stat.label, style: TextStyle(color: Colors.blue[200], fontSize: 14)),
          ],
        );
      }).toList(),
    );
  }
}
