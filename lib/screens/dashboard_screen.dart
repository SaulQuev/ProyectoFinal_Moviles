
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData=[];

  Future<String> uploadPDF(String fileName, File file) async{
    final reference =FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});

    final downloadLink=await reference.getDownloadURL();

    return downloadLink;
  } 

  void pickFile() async{
  
  final pickedFile = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if(pickedFile != null){
    String fileName = pickedFile.files[0].name;
    File file=File(pickedFile.files[0].path!);
    
    final downloadLink = await uploadPDF(fileName, file);

    _firebaseFirestore.collection("pdfs").add({
      "name": fileName,
      "url": downloadLink
    });
    print("pdf cargado de manera eitosa");

  }
  }

  void getAllPdf() async{
    final results = await _firebaseFirestore.collection("pdfs").get();
    pdfData=results.docs.map((e) => e.data()).toList();

    setState(() {
      
    });
  }

  @override
  void initState(){
    super.initState();
    getAllPdf();
  }


  @override
  Widget build(BuildContext context) {
    //PROBAR CAMBIO EN EL TITULO DE LA PANTALLA
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTitle,
        builder: (context, value, _) {
          return Scaffold(
              appBar: AppBar(title: const Text('Bienvenidos a TecRoom 👋')),
              drawer: createDrawer(context),
              body: GridView.builder(
                itemCount: pdfData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfURl: pdfData[index]['url'])),);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/images/lince.webp",
                              height: 120,
                              width: 100,
                            ),
                            Text(
                              pdfData[index]['name'],
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.upload_file),
                onPressed: pickFile,
              ),

              /*Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://img.freepik.com/vector-premium/diseno-papel-tapiz-regreso-escuela-pizarra_23-2148606150.jpg?w=900'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              )*/
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
                backgroundImage: NetworkImage(
                    'https://scontent.fcyw4-1.fna.fbcdn.net/v/t1.6435-9/147282030_3758020080926332_2824307540345505213_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=be3454&_nc_ohc=2KIApUETjWcAX_iBwLT&_nc_ht=scontent.fcyw4-1.fna&oh=00_AfB8uR83t7Rc-W1iT-dfqZIIHjPdPw3YTvTc3Tk9wzx9PQ&oe=657EB2A7'), //'https://i.pravatar.cc/300'
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



class PdfViewerScreen extends StatefulWidget{
  final String pdfURl;
  const PdfViewerScreen({super.key, required this.pdfURl});

  @override
  State<PdfViewerScreen> createState()=> _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen>{
  PDFDocument? document;
  void initialisePDF()async{
    document= await PDFDocument.fromURL(widget.pdfURl);
    setState(() {
      
    });
  }

  @override
  void initState(){
    super.initState();
    initialisePDF();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: document != null? PDFViewer(document: document!,
      ): Center( child: CircularProgressIndicator()),
    );
  }
}
