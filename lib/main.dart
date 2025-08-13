import 'package:expro_archives/DecisionCubit/decision_cubit.dart';
import 'package:expro_archives/cubit/workflowcubit/workflow_cubit.dart';
import 'package:expro_archives/views/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // تم توليده عبر FlutterFire CLI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        BlocProvider<WorkflowCubit>(create: (_) => WorkflowCubit()),
        BlocProvider<DecisionCubit>(create: (_) => DecisionCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
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
        home: DashboardScreen(),
      ),
    );
  }
}
