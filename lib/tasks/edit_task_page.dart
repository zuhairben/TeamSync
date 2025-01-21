import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_flutter/bloc/task/task_bloc.dart';
import 'package:firebase_flutter/bloc/task/task_event.dart';
import 'package:firebase_flutter/bloc/task/task_state.dart';
import 'package:firebase_flutter/models/task_model.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;
  String? _assignedToEmail;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the existing task data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _deadlineController = TextEditingController(text: widget.task.dueDate.toIso8601String().split('T')[0]);
    _assignedToEmail = widget.task.assignedTo;

    // Fetch team members for the dropdown
    context.read<TaskBloc>().add(FetchTeamMembersEvent());
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id, // Keep the same task ID
        title: _titleController.text,
        description: _descriptionController.text,
        assignedTo: _assignedToEmail ?? widget.task.assignedTo,
        status: widget.task.status, // Keep the current status
        dueDate: DateTime.parse(_deadlineController.text),
        createdBy: widget.task.createdBy, // Keep the creator unchanged
      );

      context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask)); // Update the task via bloc
      Navigator.pop(context); // Navigate back after updating
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
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
                      onPressed: _updateTask,
                      child: const Text('Update Task'),
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
