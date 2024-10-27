import 'package:flutter/material.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int counter = 0;

// initState
  @override
  void initState() {
    counter = 10;
    super.initState();
  }

  // dispose: Giải phóng bộ nhớ
  @override
  void dispose() {
    super.dispose();
  }

  // viết hàm counter bên ngoài
  // hàm tăng:
  void increase() {
    setState(() {
      counter++;
    });
  }

  // Hàm giảm:
  void decrease() {
    setState(() {
      counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("2221050601 Nguyễn Hữu Vinh"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Counter: $counter",
              style: theme.textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                  onPressed: decrease, child: const Text("Prev Counter")),
            ),
            FilledButton(
                onPressed: increase, child: const Text("Next Counter")),
          ],
        ),
      ),
    );
  }
}
