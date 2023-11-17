import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/class_model.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

class AddClassScreen extends StatefulWidget {
  AddClassScreen({super.key, this.classModel});

  ClassModel? classModel;

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  TextEditingController txtContClassName = TextEditingController();
  Agenda? agendadb;

  @override
  void initState() {
    super.initState();
    agendadb = Agenda();
    txtContClassName.text =
        widget.classModel == null ? "" : widget.classModel!.class_name!;
  }

  @override
  Widget build(BuildContext context) {
    final txtClassName = TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text("Agregar Clase")),
      controller: txtContClassName,
    );

    final btnSave = ElevatedButton(
        onPressed: () {
          if (widget.classModel == null) {
            if (txtContClassName.text == "") {
              ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.warning,
                      title: "¡Advertencia!",
                      text: "Porfavor, llenar todos lo espacios"));
            } else {
              agendadb!.INSERT('class',
                  {'class_name': txtContClassName.text}).then((value) {
                var msj = (value > 0)
                    ? 'Clase agregada Correctamente'
                    : 'Algo Fallo';
                var snackBar = SnackBar(content: Text(msj));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              });
            }
          } else {
            agendadb!.UPDATE('class', 'class_id', {
              "class_id": widget.classModel!.class_id,
              "class_name": txtContClassName.text
            }).then((value) {
              var msj = (value > 0)
                  ? 'Clase Actualizada Correctamente'
                  : 'Algo Fallo';
              var snackBar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            });
          }
          GlobalValues.flag_database.value = !GlobalValues.flag_database.value;
        },
        child: const Text("Guardar"));

    const space = SizedBox(
      height: 10,
    );

    return Scaffold(
      appBar: AppBar(
        title: widget.classModel == null
            ? const Text('Agregar Clase')
            : const Text('Actualizar Clase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [txtClassName, space, btnSave],
        ),
      ),
    );
  }
}
