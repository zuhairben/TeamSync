import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = [];  // Each task will now also contain a list of comments
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({'name': _taskController.text, 'status': 'To Do', 'comments': []});  // Task with an empty comments list
      });
      _taskController.clear();
    }
  }

  void _addComment(int taskIndex) {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _tasks[taskIndex]['comments'].add(_commentController.text);  // Add comment to the task's comment list
      });
      _commentController.clear();
    }
  }

  void _updateTaskStatus(int index, String newStatus) {
    setState(() {
      _tasks[index]['status'] = newStatus;  // Update the status of the task
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Enter Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    _tasks[index]['name'],
                    style: TextStyle(
                      color: _tasks[index]['status'] == 'Completed' ? Colors.green :
                      _tasks[index]['status'] == 'In Progress' ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Text('Status: ${_tasks[index]['status']}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String value) {
                      _updateTaskStatus(index, value);
                    },
                    itemBuilder: (BuildContext context) {
                      return ['To Do', 'In Progress', 'Completed'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    child: Icon(Icons.more_vert),
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tasks[index]['comments'].length,
                      itemBuilder: (context, commentIndex) {
                        return ListTile(
                          title: Text(_tasks[index]['comments'][commentIndex]),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: 'Add Comment',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => _addComment(index),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
