import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/class_model.dart';
import 'package:proyecto_moviles/models/teacher_model.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

class AddTeacherScreen extends StatefulWidget {
  AddTeacherScreen({super.key, this.teacherModel});

  TeacherModel? teacherModel;

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  TextEditingController txtContTeacherName = TextEditingController();
  TextEditingController txtContTeacherEmail = TextEditingController();
  ClassModel? dropDownValue;
  List<ClassModel>? dropDownValues;
  Agenda? agendadb;

  @override
  void initState() {
    super.initState();
    agendadb = Agenda();
    if (widget.teacherModel != null) {
      txtContTeacherName.text = widget.teacherModel!.teacher_name!;
      txtContTeacherEmail.text = widget.teacherModel!.teacher_email!;
      getClass();
    } else {
      getClasses();
    }
  }

  Future getClass() async {
    final class1 = await agendadb!.GETCLASS(widget.teacherModel!.class_id!);
    final classes = await agendadb!.GETALLCLASS();
    setState(() {
      dropDownValues = classes;
      for (int i = 0; i < classes.length; i++) {
        if (classes[i].class_id == class1.class_id) {
          dropDownValue = classes[i];
          break;
        }
      }
    });
  }

  Future getClasses() async {
    final classes = await agendadb!.GETALLCLASS();
    setState(() {
      dropDownValues = classes;
      dropDownValue = classes[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final txtTeacherName = TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text("Nombre de Profesor")),
      controller: txtContTeacherName,
    );

    final txtTeacherEmail = TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text("Correo Electronico")),
      controller: txtContTeacherEmail,
    );

    const space = SizedBox(
      height: 10,
    );

    final btnSave = ElevatedButton(
        onPressed: () {
          if (widget.teacherModel == null) {
            if (txtContTeacherName.text == "" ||
                txtContTeacherEmail.text == "") {
              ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.warning,
                      title: "¡Advertencia!",
                      text: "Porfavor, llenar todos lo espacios"));
            } else {
              agendadb!.INSERT('teachers', {
                "teacher_name": txtContTeacherName.text,
                "teacher_email": txtContTeacherEmail.text,
                "class_id": dropDownValue!.class_id
              }).then((value) {
                var msj = (value > 0)
                    ? 'Profesor Agregado Correctamente'
                    : 'Algo Fallo';
                var snackBar = SnackBar(content: Text(msj));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              });
            }
          } else {
            agendadb!.UPDATE('teachers', 'teacher_id', {
              "teacher_id": widget.teacherModel!.teacher_id,
              "teacher_name": txtContTeacherName.text,
              "teacher_email": txtContTeacherEmail.text,
              "class_id": dropDownValue!.class_id
            }).then((value) {
              var msj = (value > 0)
                  ? 'Profesor Actualizado Correctamente'
                  : 'Algo Fallo';
              var snackBar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            });
          }
          GlobalValues.flag_database.value = !GlobalValues.flag_database.value;
        },
        child: const Text("Guardar")
      );

    final DropdownButton dropDownButtonClass = DropdownButton(
        value: dropDownValue,
        items: dropDownValues
            ?.map((class1) => DropdownMenuItem(
                value: class1, child: Text(class1.class_name!)))
            .toList(),
        onChanged: (value) {
          dropDownValue = value;
          setState(() {});
        });

    return Scaffold(
      appBar: AppBar(
        title: widget.teacherModel == null
            ? const Text('Agregar Profesor')
            : const Text('Actualizar Profesor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtTeacherName,
            space,
            txtTeacherEmail,
            space,
            dropDownButtonClass,
            space,
            btnSave
          ],
        ),
      ),
    );
  }
}
