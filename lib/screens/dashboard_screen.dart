
import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:proyecto_moviles/styles/global_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var img;
   late String img64;
  @override
  Widget build(BuildContext context) {
    //PROBAR CAMBIO EN EL TITULO DE LA PANTALLA
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTitle,
        builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bienvenidos a TecRoom 👋')),
            drawer: createDrawer(context),
          );
        });

  
  }
  
  
  Widget createDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
         GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/Foto');
          },
           child: const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://scontent.fcyw4-1.fna.fbcdn.net/v/t1.6435-9/147282030_3758020080926332_2824307540345505213_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=be3454&_nc_ohc=2KIApUETjWcAX_iBwLT&_nc_ht=scontent.fcyw4-1.fna&oh=00_AfB8uR83t7Rc-W1iT-dfqZIIHjPdPw3YTvTc3Tk9wzx9PQ&oe=657EB2A7'),//'https://i.pravatar.cc/300'
              ),
              
              
              
              accountName: Text('Saul Quevedo Hernandez'),
              accountEmail: Text('19030099@itcelaya.edu.mx'),
            ),
         ),
          ListTile(
            leading: Image.asset('assets/images/tecno.png'),
            trailing: const Icon(Icons.verified),
            title: const Text('Instituto Tecnologico de Celaya'),
            /*subtitle: const Text('Acerca de...'),
            onTap: () {
              //Navigator.pushNamed(context, '/item');
            },*/
          ),
          ListTile(
            leading: Image.asset('assets/images/carrera.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Administrador Clases'),
            onTap: () {
              Navigator.pushNamed(context, '/class');
            },
          ),
        
          ListTile(
            leading: Image.asset('assets/images/profe.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Administrador Profesores'),
            onTap: () {
              Navigator.pushNamed(context, '/teachers');
            },
          ),
            ListTile(
            leading: Image.asset('assets/images/tarea.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Administrador Tareas'),
            onTap: () {
              Navigator.pushNamed(context, '/tasks');
            },
          ),
          
          ListTile(
            leading: Image.asset('assets/images/calendario.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Calendario'),
            onTap: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/maps.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Mapas'),
            onTap: () {
              Navigator.pushNamed(context, '/maps');
            },
          ),
          const Spacer(
            flex: 1,
          ),
          DayNightSwitcher(
            isDarkModeEnabled: GlobalValues.flagTheme.value,
            onStateChanged: (isDarkModeEnabled) async {
              GlobalValues.flagTheme.value = isDarkModeEnabled;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('darkTheme', isDarkModeEnabled);
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset('assets/images/logout.png'),
            title: const Text('Cerrar sesion'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLogged', false);
              Navigator.pushNamed(context, '/login');
            },
          ),
          
        ],
        
      ),
      
    );
    
  }
}
