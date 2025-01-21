// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/auth/AuthService.dart';
import 'package:firebase_flutter/auth/login_screen.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';
import 'package:firebase_flutter/home/home.dart';
import 'package:firebase_flutter/tasks/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_flutter/dashboard/admin_dashboard.dart';
import 'package:firebase_flutter/dashboard/team_member_dashboard.dart';
import 'package:firebase_flutter/bloc/auth/auth_bloc.dart';
import 'package:firebase_flutter/bloc/auth/auth_state.dart';
import 'package:firebase_flutter/bloc/auth/auth_event.dart';
import 'package:firebase_flutter/bloc/task/task_bloc.dart';
import 'package:firebase_flutter/bloc/task/task_event.dart';
import 'package:firebase_flutter/tasks/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => TaskBloc(TaskService())..add(LoadTasks()),
        ),
      ],
      child: MaterialApp(
        title: 'Team Sync',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/home': (context) => const HomePage(),
          '/adminDashboard': (context) => AdminDashboard(),
          '/teamMemberDashboard': (context) => TeamMemberDashboard(),
          '/signup': (context) => SignupScreen(
            signup: (email, password, role) async {
              BlocProvider.of<AuthBloc>(context).add(SignupEvent(email, password, role));
              Navigator.pop(context); // Navigate back to login screen after signup
            },
            login: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          '/addTask': (context) => AddTaskPage(),
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildScreen(context);
      },
    );
  }

  Widget _buildScreen(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitialState || state is AuthFailureState) {
          return LoginScreen(
            login: (email, password) {
              BlocProvider.of<AuthBloc>(context).add(LoginEvent(email, password));
            },
            signup: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupScreen(
                    signup: (email, password, role) async {
                      BlocProvider.of<AuthBloc>(context).add(SignupEvent(email, password, role));
                      Navigator.pop(context); // Return to login screen after signup
                    },
                    login: () {
                      Navigator.pop(context); // Navigate back to login
                    },
                  ),
                ),
              );
            },
          );
        }

        if (state is AuthSuccessState) {
          return const HomePage();
        }

        return const Center(child: Text('Unexpected State'));
      },
    );
  }
}
