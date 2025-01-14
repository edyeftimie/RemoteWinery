class LogRepository {
  final List<Map<String, dynamic>> _logs_queue;

  LogRepository() : _logs_queue = [];

  void addLog(Map<String, dynamic> log) {
    _logs_queue.add(log);
  }

  List<Map<String, dynamic>> getLogs() {
    return _logs_queue;
  }

  bool editLogsWineID(int oldID, int newID) {
    for (var log in _logs_queue) {
      if (log["wine"]["id"] == oldID) {
        log["wine"]["id"] = newID;
        return true;
      }
    }

    return false;
  }

  Map<String, dynamic> getFirstLog() {
    if (!_logs_queue.isEmpty) {
      var first_log = _logs_queue.first;
      _logs_queue.removeAt(0);
      return first_log;
    }

    String message = "No logs available";
    var map = Map<String, dynamic>();
    map["message"] = message;

    return map;
  }
}