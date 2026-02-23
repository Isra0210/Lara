class TimeUtils {
  static String formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();

    if (timestamp.isAfter(now)) return 'agora';

    final difference = now.difference(timestamp);
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final daysDiff = today.difference(date).inDays;

    // Today
    if (daysDiff == 0) {
      if (difference.inMinutes < 1) {
        return 'agora';
      }

      if (difference.inHours < 1) {
        final minutes = difference.inMinutes;
        return 'há $minutes min';
      }

      final hours = difference.inHours;
      return 'há ${hours}h';
    }

    // Yesterday
    if (daysDiff == 1) {
      return 'ontem';
    }

    // Within the last week
    if (daysDiff < 7) {
      const weekDays = [
        'segunda-feira',
        'terça-feira',
        'quarta-feira',
        'quinta-feira',
        'sexta-feira',
        'sábado',
        'domingo',
      ];

      return weekDays[timestamp.weekday - 1];
    }

    // Complete date for older time
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    final year = timestamp.year.toString();

    return '$day/$month/$year';
  }
}
