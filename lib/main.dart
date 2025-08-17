import 'package:expro_archives/cubit/DecisionCubit/decision_cubit.dart';
import 'package:expro_archives/cubit/autho/auth_cubit.dart';
import 'package:expro_archives/cubit/workflowcubit/workflow_cubit.dart';
import 'package:expro_archives/views/dash_board.dart';
import 'package:expro_archives/views/login_page.dart';
import 'package:expro_archives/views/registe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ تهيئة Supabase
  await supa.Supabase.initialize(
    url: 'https://ftlbtuovvqjnebibhlql.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0bGJ0dW92dnFqbmViaWJobHFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzNjg4MDgsImV4cCI6MjA3MDk0NDgwOH0.dJoVwlA2Bbdpbg4Gs6wjLKnrV5CyJl2zi6sETv7kPfg',
  );

  // تهيئة بيانات التاريخ للغة العربية
  await initializeDateFormatting('ar', null);

  runApp(const ExproArchives());
}

class ExproArchives extends StatelessWidget {
  const ExproArchives({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<WorkflowCubit>(create: (_) => WorkflowCubit()),
        BlocProvider<DecisionCubit>(create: (_) => DecisionCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xffdbdbdb),
          primaryColor: const Color(0xFF3E3E55),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardScreen(),
        },

        home: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          },
          child: const LoginPage(),
        ),
      ),
    );
  }
}
