import 'package:firebase_flutter/models/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}

class TeamMembersFetchedState extends TaskState { // Added a state for team members
  final List<Map<String, String>> teamMembers;
  TeamMembersFetchedState(this.teamMembers);
}
