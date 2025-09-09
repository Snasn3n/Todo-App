// lib/main.dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple ToDo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoHome(),
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});
  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.insert(0, {'title': text, 'done': false});
    });
    _controller.clear();
  }

  void _toggleDone(int index) {
    setState(() => _tasks[index]['done'] = !_tasks[index]['done']);
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog() async {
    _controller.clear();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neue Aufgabe'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(context).pop(value),
          decoration: const InputDecoration(hintText: 'Aufgaben-Titel'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(_controller.text), child: const Text('Hinzufügen')),
        ],
      ),
    );
    if (result != null) _addTask(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple ToDo')),
      body: _tasks.isEmpty
          ? const Center(child: Text('Keine Aufgaben. Tippe + um eine hinzuzufügen.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key('${task['title']}_$index'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) => _removeTask(index),
                  child: CheckboxListTile(
                    title: Text(
                      task['title'],
                      style: task['done'] ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                    ),
                    value: task['done'] as bool,
                    onChanged: (_) => _toggleDone(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}