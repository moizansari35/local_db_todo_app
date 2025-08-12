import 'package:flutter/material.dart';
import 'package:local_db_app/models/task_model.dart';

import '../db/db_helper.dart';

enum TaskStatusFilter { all, completed, notCompleted }

class TaskViewModel with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  bool _isGridView = false;
  bool get isGridView => _isGridView;

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  TaskStatusFilter _filter = TaskStatusFilter.all;
  TaskStatusFilter get filter => _filter;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;

  List<Task> get filteredTasks {
    List<Task> filtered = [..._tasks];

    // Apply filter
    if (_filter == TaskStatusFilter.completed) {
      filtered = filtered.where((task) => task.isCompleted).toList();
    } else if (_filter == TaskStatusFilter.notCompleted) {
      filtered = filtered.where((task) => !task.isCompleted).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (task) => task.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    return filtered;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(TaskStatusFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.insertTask(task);
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _dbHelper.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await fetchTasks();
  }

  void toggleTodoStatus(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
      await _dbHelper.updateTask(_tasks[index]);
    }
  }
}
