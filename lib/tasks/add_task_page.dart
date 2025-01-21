import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_flutter/bloc/task/task_bloc.dart';
import 'package:firebase_flutter/bloc/task/task_event.dart';
import 'package:firebase_flutter/bloc/task/task_state.dart';
import 'package:firebase_flutter/models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  String? _assignedToEmail;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTeamMembersEvent()); // Trigger team members fetch
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        assignedTo: _assignedToEmail ?? '',
        status: 'To Do',
        dueDate: DateTime.parse(_deadlineController.text),
        createdBy: 'admin@example.com', // Example createdBy value
      );

      context.read<TaskBloc>().add(AddTaskEvent(task)); // Add the task via bloc
      Navigator.pop(context); // Navigate back after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamMembersFetchedState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                      validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _assignedToEmail,
                      decoration: const InputDecoration(labelText: 'Assign To'),
                      items: state.teamMembers.map((member) {
                        return DropdownMenuItem(
                          value: member['email'],
                          child: Text(member['email']!),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _assignedToEmail = value),
                      validator: (value) =>
                      value == null ? 'Select a team member' : null,
                    ),
                    TextFormField(
                      controller: _deadlineController,
                      decoration: const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                      validator: (value) =>
                      value!.isEmpty ? 'Enter a valid deadline' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitTask,
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Error loading team members'));
          }
        },
      ),
    );
  }
}
