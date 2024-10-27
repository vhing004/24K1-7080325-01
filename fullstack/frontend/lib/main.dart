import 'package:flutter/material.dart';
import 'package:frontend/views/todo_view.dart';
import 'package:intl/intl.dart'; // Để định dạng và phân tích ngày tháng

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng full-stack flutter đơn giản',
      home: TodoView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _displayName = '';
  String _displayAge = '';

  // Hàm tính tuổi dựa vào ngày sinh
  String _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  // Hàm xử lý khi ấn nút
  void _onCalculateButtonPressed() {
    String name = _nameController.text;
    String dobText = _dobController.text;

    // Phân tích ngày sinh và tính tuổi
    try {
      DateTime dob = DateFormat('dd/MM/yyyy').parse(dobText);
      String age = _calculateAge(dob);

      // Cập nhật trạng thái để hiển thị tên và tuổi
      setState(() {
        _displayName = name;
        _displayAge = age;
      });
    } catch (e) {
      // Xử lý khi định dạng ngày không hợp lệ
      setState(() {
        _displayName = 'Ngày sinh không hợp lệ';
        _displayAge = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nhập tên của bạn',
              ),
            ),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Nhập ngày sinh (dd/MM/yyyy)',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onCalculateButtonPressed, // Gọi hàm khi ấn nút
              child: const Text('Tính tuổi và hiển thị'),
            ),
            const SizedBox(height: 20),
            if (_displayName.isNotEmpty) Text('Tên: $_displayName'),
            if (_displayAge.isNotEmpty) Text('Tuổi: $_displayAge'),
          ],
        ),
      ),
    );
  }
}
