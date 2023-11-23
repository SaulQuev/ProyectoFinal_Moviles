import 'package:flutter/widgets.dart';
import 'package:proyecto_moviles/screens/add_class_screen.dart';
import 'package:proyecto_moviles/screens/add_task_screen.dart';
import 'package:proyecto_moviles/screens/add_teacher_screen.dart';
import 'package:proyecto_moviles/screens/calendar_screen.dart';
import 'package:proyecto_moviles/screens/cambio_foto.dart';
import 'package:proyecto_moviles/screens/class_screen.dart';
import 'package:proyecto_moviles/screens/dashboard_screen.dart';
import 'package:proyecto_moviles/screens/login.dart';
import 'package:proyecto_moviles/screens/login_screen.dart';
import 'package:proyecto_moviles/screens/maps_screen.dart';
import 'package:proyecto_moviles/screens/provider_screen.dart';
import 'package:proyecto_moviles/screens/register_screen.dart';
import 'package:proyecto_moviles/screens/task_screen.dart';
import 'package:proyecto_moviles/screens/teacher_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/login': (BuildContext context) => const login_screen(),
    '/dash': (BuildContext context) => const DashboardScreen(),
    '/tasks': (BuildContext context) => const TaskScreen(),
    '/addTask': (BuildContext context) => AddTaskScreen(),
    '/class': (BuildContext context) => const ClassScreen(),
    '/addClass': (BuildContext context) => AddClassScreen(),
    '/teachers': (BuildContext context) => const TeacherScreen(),
    '/addTeacher': (BuildContext context) => AddTeacherScreen(),
    '/provider': (BuildContext context) => const ProviderScreen(),
    '/calendar': (BuildContext context) => const CalendarScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/maps': (BuildContext context) => const MapSample(),
    '/Foto': (BuildContext context) => const CambioFoto(),
  };
}
