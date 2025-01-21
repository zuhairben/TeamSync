import 'package:firebase_flutter/models/task_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent { // Updated the event name to AddTaskEvent
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent { // Updated the event name
  final Task task;
  UpdateTaskEvent(this.task);
}

class UpdateTaskStatusEvent extends TaskEvent { // Updated the event name
  final String taskId;
  final String newStatus;
  UpdateTaskStatusEvent(this.taskId, this.newStatus);
}

class FetchTeamMembersEvent extends TaskEvent {} // Added a new event for team members
