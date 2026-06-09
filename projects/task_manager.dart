enum Priority { low, medium, high }

enum Status { todo, inProgress, done }

class Task {
  final int id;
  final String title;
  final Priority priority;
  final Status status;
  final int dayDue;
  Task(this.id, this.title, this.priority, this.status, this.dayDue);

  @override
  String toString() => 'Task ($id, $title, $status)';
}

class Repository<T> {
  final List<T> _items = [];
  void add(T item) {
    _items.add(item);
  }

  // List.unmodifiable creates a read-only view of the list — you can read but not modify.
  List<T> findAll() => List.unmodifiable(_items);
  List<T> findWhere(bool Function(T) predicate) =>
      _items.where(predicate).toList();
}

class TaskAnalytics {
  final List<Task> _tasks;
  TaskAnalytics(this._tasks);

  Map<Status, List<Task>> groupByStatus() {
    final map = <Status, List<Task>>{};
    for (final t in _tasks) {
      map.putIfAbsent(t.status, () => []).add(t); // manual groupBy
    }
    return map;
  }

  Map<Priority, int> countByPriority() {
    final map = <Priority, int>{};
    for (final t in _tasks) {
      map.update(t.priority, (v) => v + 1, ifAbsent: () => 1);
    }
    return map;
  }

  List<Task> overdue(int today) =>
      _tasks.where((t) => t.status != Status.done && t.dayDue < today).toList()
        ..sort((a, b) => a.dayDue.compareTo(b.dayDue));

  double completionRate() {
    if (_tasks.isEmpty) return 0.0;
    final done = _tasks.where((t) => t.status == Status.done).length;
    return done / _tasks.length * 100;
  }
}

void main(List<String> args) {
  final repo = Repository<Task>();
  repo.add(Task(1, 'Write report', Priority.high, Status.todo, 5));
  repo.add(Task(2, 'Email client', Priority.medium, Status.done, 2));
  repo.add(Task(3, 'Fix bug', Priority.high, Status.inProgress, 1));
  repo.add(Task(4, 'Tidy desk', Priority.low, Status.done, 10));

  final analytics = TaskAnalytics(repo.findAll());

  print('By status: ${analytics.groupByStatus().keys}');
  print('Counts:    ${analytics.countByPriority()}');
  print('Overdue:   ${analytics.overdue(3)}'); // task 3
  print('Done: ${analytics.completionRate().toStringAsFixed(1)}%'); // 50.0%

  final highPriority = repo.findWhere((t) => t.priority == Priority.high);
  print('High priority: ${highPriority.length}');
}
