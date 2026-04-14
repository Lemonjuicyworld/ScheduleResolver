import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/schedule_provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/ai_schedule_services.dart';
void main () {

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ChangeNotifierProvider(create: (_) => AiScheduleServices())
    ],
      child: const ScheduleResolverApp(),
    )
  );

}
  class ScheduleResolverApp extends StatelessWidget {

  const ScheduleResolverApp ({super.key});

  @override
    Widget build(BuildContext context) {
    // TODO : implement build
    return MaterialApp(
      title: 'Schedule Resolver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const DashboardScreen(),
    );

  }


  }

