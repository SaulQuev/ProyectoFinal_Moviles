
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
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
  String? profileImageUrl;
  bool loading =true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  void initState() {
    super.initState();
    // Llama a una función para obtener la URL de la imagen cuando se carga la pantalla.
    fetchProfileImageUrl();
  }

  Future<void> fetchProfileImageUrl() async {
    try {
      var currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Usuario no autenticado.');
        throw Exception('Usuario no autenticado');
      }
      var userId = currentUser.uid;
      var userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        // Verifica si el documento del usuario existe en Firestore
        setState(() {
          // Actualiza el estado con la URL de la imagen
          profileImageUrl = userDoc['profileImageUrl'];
           loading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error al obtener la URL de la imagen: $e\n$stackTrace');
      setState(() {
        loading = false; // Ha ocurrido un error, establece loading en false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //PROBAR CAMBIO EN EL TITULO DE LA PANTALLA
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTitle,
        builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bienvenidos 👋')),
            drawer: createDrawer(context),
          );
        });

  
  }
  
  final imgLogo = Container(
      width: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/2919/2919600.png')),
      ),
    );

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
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Instituto Tecnologico de Celaya'),
            subtitle: const Text('Acerca de...'),
            onTap: () {
              //Navigator.pushNamed(context, '/item');
            },
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
            leading: Image.asset('assets/images/test.png'),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('Test Provider'),
            onTap: () {
              Navigator.pushNamed(context, '/provider');
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
