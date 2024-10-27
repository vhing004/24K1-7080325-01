import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
// C1:
// List<String> tasks = [];
// C2:
  final tasks = ["2221050601-Nguyễn Hữu Vinh"];

  TextEditingController taskController = TextEditingController();

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: taskController,
              decoration: const InputDecoration(labelText: "Nhap cong viec "),
            ),
          ),
          ElevatedButton(
              onPressed: addJob, child: const Text("Add Job Favorite")),

          // Cách tự nghĩ:
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Column(
          //         children: tasks.map((data) => Text(data)).toList(),
          //       )
          //     ],
          //   ),
          // )

          Expanded(
            child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks.elementAt(index)),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  );
                }),
          )
        ],
      ),
    );
  }

// Hàm add Job
  void addJob() {
    setState(() {
      if (taskController.text == '') {
        return;
      }
      tasks.add(taskController.text);
      taskController.clear();
    });
  }
}
