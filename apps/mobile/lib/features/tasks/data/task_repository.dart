import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savj_mobile/core/api/providers.dart';
import 'package:savj_mobile/features/tasks/domain/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(dioProvider));
});

class TaskRepository {
  final Dio _dio;

  TaskRepository(this._dio);

  Future<List<TaskModel>> fetchNearbyTasks() async {
    try {
      final response = await _dio.get('/api/tasks/nearby');
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List items = response.data['data'];
        return items.map((e) => TaskModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch tasks: ${e.toString()}');
    }
  }

  Future<List<TaskModel>> fetchAllTasks() async {
    try {
      final response = await _dio.get('/api/tasks');
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List items = response.data['data'];
        return items.map((e) => TaskModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch tasks: ${e.toString()}');
    }
  }

  Future<bool> createTask(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/api/tasks', data: payload);
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }
}
