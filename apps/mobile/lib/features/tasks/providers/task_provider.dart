import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savj_mobile/features/tasks/data/task_repository.dart';
import 'package:savj_mobile/features/tasks/domain/task_model.dart';

// Fetches all nearby tasks (no GPS required — returns all open tasks from API)
final nearbyTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.fetchNearbyTasks();
});

// Fetches all tasks
final allTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.fetchAllTasks();
});
