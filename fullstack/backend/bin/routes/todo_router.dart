// Lớp định nghĩa các router cho hoạt động  CRUD trên Todo
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/todo_models.dart';

class TodoRouter {
// danh sách các công việc đc quản lý bởi backend
  final _todos = <TodoModels>[];

// Tạo và trả về 1 Router cho các hạot đôgnj CRUD  trên TOdo
  Router get router {
    final router = Router();

    // Endpoint lấy danh sách tất cả cacs cônng việc
    router.get('/todos', _getTodoHandler);

    // Endpoint thêm danh sách tất cả cacs cônng việc
    router.post('/todos', _addTodoHandler);

    // Endpoint xóa id
    router.delete('/todos/<id>', _deleteTodoHandler);

    // Endpoint cập nhật danh sách id
    router.put('/todos/<id>', _updateTodoHandler);

    return router;
  }

// header mặc định cho dữ liệu  trả về dưới dạng json
  static final _headers = {'Conten-Type': 'application/json'};

// Xử lý yêu cầu lấy công việc
  Future<Response> _getTodoHandler(Request req) async {
    try {
      final body = json.encode(_todos.map((todo) => todo.toMap()).toList());

      return Response.ok(
        body,
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

// Xử lý yêu cầu thêm công việc
  Future<Response> _addTodoHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      final todo = TodoModels.fromMap(data);
      _todos.add(todo);

      return Response.ok(
        todo.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

// Xử lý yêu cầu xóa công việc
  Future<Response> _deleteTodoHandler(Request req, String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == int.parse(id));
      if (index == -1) {
        return Response.notFound("Not Fount id = $id !");
      }

      final removedTodo = _todos.removeAt(index);

      return Response.ok(
        removedTodo.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

// Xử lý yêu cầu xóa công việc
  Future<Response> _updateTodoHandler(Request req, String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == int.parse(id));
      if (index == -1) {
        return Response.notFound("Not Fount id = $id !");
      }

      final payload = await req.readAsString();
      final map = json.decode(payload);
      final updatedTodo = TodoModels.fromMap(map);

      _todos[index] = updatedTodo;

      return Response.ok(
        updatedTodo.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }
}
