import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarProvider =
    StateNotifierProvider<CalendarState, List<Map<String, dynamic>>>((ref) {
  return CalendarState();
});

class CalendarState extends StateNotifier<List<Map<String, dynamic>>> {
  CalendarState() : super([]);

  void addEvent(Map<String, dynamic> event) {
    state = [...state, event];
    print("New State: $state"); // Add this line
  }
}
