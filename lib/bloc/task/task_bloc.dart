import 'package:firebase_flutter/bloc/task/task_event.dart';
import 'package:firebase_flutter/bloc/task/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_flutter/tasks/task_service.dart';
import 'package:firebase_flutter/models/task_model.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskBloc(this.taskService) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasksStream = taskService.getTasks();
        await emit.forEach<List<Task>>(tasksStream, onData: (tasks) => TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to load tasks: $e'));
      }
    });

    on<AddTaskEvent>((event, emit) async { // Updated the event name
      try {
        await taskService.addTask(event.task);
      } catch (e) {
        emit(TaskError('Failed to add task: $e'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async { // Updated the event name
      try {
        await taskService.updateTask(event.task);
      } catch (e) {
        emit(TaskError('Failed to update task: $e'));
      }
    });

    on<UpdateTaskStatusEvent>((event, emit) async { // Updated the event name
      try {
        await taskService.updateTaskStatus(event.taskId, event.newStatus);
      } catch (e) {
        emit(TaskError('Failed to update task status: $e'));
      }
    });

    on<FetchTeamMembersEvent>((event, emit) async { // Added handler for fetching team members
      try {
        final teamMembers = await taskService.getTeamMembers();
        emit(TeamMembersFetchedState(teamMembers));
      } catch (e) {
        emit(TaskError('Failed to fetch team members: $e'));
      }
    });
  }
}
