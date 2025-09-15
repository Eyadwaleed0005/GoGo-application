import 'package:flutter/material.dart';

class TripSummaryCard extends StatelessWidget {
  final double distanceKm;
  final double durationMin;

  const TripSummaryCard({
    super.key,
    required this.distanceKm,
    required this.durationMin,
  });

  /// تحويل الدقائق إلى الساعات مع عشرية (مثلاً 90 دقيقة -> 1.5h)
  String _formatTimeInHours(double minutes) {
    final hours = minutes / 60;
    return hours.toStringAsFixed(1) + "h";
  }

  /// تنسيق المسافة بالكيلومتر
  String _formatDistance(double km) {
    return km < 10 ? km.toStringAsFixed(1) : km.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(
              Icons.route,
              "Distance",
              "${_formatDistance(distanceKm)} Km",
              Colors.blue[800],
            ),
            _buildItem(
              Icons.schedule,
              "Time",
              _formatTimeInHours(durationMin),
              Colors.green[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value, Color? color) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              "$label: $value",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
