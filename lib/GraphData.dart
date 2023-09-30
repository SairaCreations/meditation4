//pojo kind class to hold graphdata with getter setters
class GraphData {
  int _startOfDay = 0;
  int _endOfDay = 0;
  int _totalMinutes = 0;
  int _dayOfWeek = 0;

  GraphData() {
    startOfDay = 0;
    endOfDay = 0;
    totalMinutes = 0;
    dayOfWeek = 0;
  }
  // Getters and setters for startOfDay
  int get startOfDay => _startOfDay;
  set startOfDay(int startOfDay) => _startOfDay = startOfDay;

  // Getters and setters for endOfDay
  int get endOfDay => _endOfDay;
  set endOfDay(int endOfDay) => _endOfDay = endOfDay;

  // Getters and setters for totalMinutes
  int get totalMinutes => _totalMinutes;
  set totalMinutes(int totalMinutes) => _totalMinutes = totalMinutes;

  // Getters and setters for dayOfWeek
  int get dayOfWeek => _dayOfWeek;
  set dayOfWeek(int dayOfWeek) => _dayOfWeek = dayOfWeek;
}
