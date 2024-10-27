import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/todo_models.dart';

String getBackendUrl() {
  if (kIsWeb) {
    return 'http://localhost:8080'; // hoặc sử dụng IP LAN nếu cần
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2:8080'; // cho emulator
    // return 'http://192.168.1.x:8080'; // cho thiết bị thật khi truy cập qua LAN
  } else {
    return 'http://localhost:8080';
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _controller = TextEditingController();
  final _todos = <TodoModels>[];
  final _headers = {'Conten-Type': 'application/json'};
  final apiUrl = '${getBackendUrl()}/api/v1/todos';

// Lấy danh sách TODO
  Future<void> _fetchTodos() async {
    final res = await http.get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      final List<dynamic> todoList = json.decode(res.body);
      setState(() {
        _todos.clear();
        _todos.addAll(todoList.map((e) => TodoModels.fromMap(e)).toList());
      });
    }
  }

// Thêm 1 todo mới vào phưuogn thức POST:
  Future<void> _addJob() async {
    if (_controller.text.isEmpty) return;

    final newItem = TodoModels(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _controller.text,
      completed: false,
    );

    final res = await http.post(
      Uri.parse(apiUrl),
      headers: _headers,
      body: json.encode(newItem.toMap()),
    );

    if (res.statusCode == 200) {
      _controller.clear();
      _fetchTodos();
    }
  }

  // cập nhất trạng thái completed  của todo sử dụng  phương thức PUT
  Future<void> _updateJob(TodoModels item) async {
    item.completed = !item.completed;
    final res = await http.put(
      Uri.parse('$apiUrl/${item.id}'),
      headers: _headers,
      body: json.encode(item.toMap()),
    );

    if (res.statusCode == 200) {
      _fetchTodos(); // cập nhật lại danh sách TODO
    }
  }

  // delete
  Future<void> _deleteJob(int id) async {
    final res = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (res.statusCode == 200) {
      _fetchTodos(); // cập nhật lại danh sách TODO
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "New Todo",
                  ),
                )),
                IconButton(
                  onPressed: _addJob,
                  icon: Icon(Icons.add),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final item = _todos.elementAt(index);
                  return ListTile(
                      leading: Checkbox(
                          value: item.completed,
                          onChanged: (value) {
                            _updateJob(item);
                          }),
                      title: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            _deleteJob(item.id);
                          },
                          icon: Icon(Icons.delete)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
