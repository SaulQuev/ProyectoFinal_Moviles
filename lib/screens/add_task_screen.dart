import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/task_model.dart';
import 'package:proyecto_moviles/models/teacher_model.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key, this.taskModel});

  TaskModel? taskModel;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController txtContTaskName = TextEditingController();
  TextEditingController txtContTaskDesc = TextEditingController();
  TextEditingController txtContTaskExp = TextEditingController();
  String? reminder;
  TeacherModel? dropDownValue;
  List<TeacherModel>? dropDownValues;
  DateTime? pickedDate;
  Agenda? agendadb;

  String? dropValueState = "Sin Completar";
  List<String>? dropStateValues = ["Sin Completar", "Completada"];

  @override
  void initState() {
    super.initState();
    agendadb = Agenda();

    if (widget.taskModel != null) {
      txtContTaskName.text = widget.taskModel!.task_name!;
      txtContTaskDesc.text = widget.taskModel!.task_desc!;
      txtContTaskExp.text = widget.taskModel!.expiration_date!;
      reminder = widget.taskModel!.alert_date!;
      dropValueState =
          widget.taskModel!.task_state! == 0 ? "Sin Completar" : "Completada";
      getTeacher();
    } else {
      getTeachers();
    }
  }

  Future getTeacher() async {
    final teacher = await agendadb!.GETTEACHER(widget.taskModel!.teacher_id!);
    final teachers = await agendadb!.GETALLTEACHERS();
    setState(() {
      dropDownValues = teachers;
      for (int i = 0; i < teachers.length; i++) {
        if (teachers[i].teacher_id == teacher.teacher_id) {
          dropDownValue = teachers[i];
          break;
        }
      }
    });
  }

  Future getTeachers() async {
    final teachers = await agendadb!.GETALLTEACHERS();
    setState(() {
      dropDownValues = teachers;
      dropDownValue = teachers[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateInput = TextField(
        controller: txtContTaskExp,
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), labelText: "Fecha de Expiracion"),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), //get today's date
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              txtContTaskExp.text = formattedDate;
              reminder = DateFormat('yyyy-MM-dd')
                  .format(pickedDate.subtract(const Duration(days: 1)));
            });
          } else {
            print("Date is not selected");
          }
        });

    final txtTaskName = TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text("Nombre de Tarea")),
      controller: txtContTaskName,
    );

    final txtTaskDesc = TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text("Descripcion")),
      maxLines: 6,
      controller: txtContTaskDesc,
    );

    const space = SizedBox(
      height: 10,
    );

    final DropdownButton dropDownButtonTeachers = DropdownButton(
        value: dropDownValue,
        items: dropDownValues
            ?.map((teacher) => DropdownMenuItem(
                value: teacher, child: Text(teacher.teacher_name!)))
            .toList(),
        onChanged: (value) {
          dropDownValue = value;
          setState(() {});
        });

    final DropdownButton dropDownButtonStates = DropdownButton(
        value: dropValueState,
        items: dropStateValues
            ?.map((state) => DropdownMenuItem(value: state, child: Text(state)))
            .toList(),
        onChanged: (value) {
          dropValueState = value;
          setState(() {});
        });

    final ElevatedButton btnSave = ElevatedButton(
        onPressed: () {
          if (widget.taskModel == null) {
            if (txtContTaskName.text == "" ||
                txtContTaskDesc.text == "" ||
                txtContTaskExp.text == "") {
              ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.warning,
                      title: "¡Advertencia!",
                      text: "Porfavor, llenar todos lo espacios"));
            } else {
              agendadb!.INSERT('tasks', {
                "task_name": txtContTaskName.text,
                "task_desc": txtContTaskDesc.text,
                "task_state": dropValueState == "Sin Completar" ? 0 : 1,
                "expiration_date": txtContTaskExp.text,
                "alert_date": reminder,
                "teacher_id": dropDownValue!.teacher_id
              }).then((value) {
                var msj = (value > 0)
                    ? 'Tarea Agregada Correctamente'
                    : 'Algo Fallo';
                var snackBar = SnackBar(content: Text(msj));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              });
            }
          } else {
            agendadb!.UPDATE('tasks', 'task_id', {
              "task_id": widget.taskModel!.task_id,
              "task_name": txtContTaskName.text,
              "task_desc": txtContTaskDesc.text,
              "task_state": dropValueState == "Sin Completar" ? 0 : 1,
              "expiration_date": txtContTaskExp.text,
              "alert_date": reminder,
              "teacher_id": dropDownValue!.teacher_id
            }).then((value) {
              var msj = (value > 0)
                  ? ' Actualizada Correctamente✅'
                  : 'Algo Fallo';
              var snackBar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              txtContTaskName.text = "";
              txtContTaskDesc.text = "";
              Navigator.pop(context);
            });
          }
          GlobalValues.flag_database.value = !GlobalValues.flag_database.value;
        },
        child: widget.taskModel == null
            ? const Text("Guardar Tarea")
            : const Text("Actualizar Tarea"));

    return Scaffold(
      appBar: AppBar(
        title: widget.taskModel == null
            ? const Text("Agregar Tarea")
            : const Text("Actualizar Tarea"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              txtTaskName,
              space,
              txtTaskDesc,
              space,
              dropDownButtonTeachers,
              space,
              dateInput,
              space,
              dropDownButtonStates,
              space,
              btnSave
            ],
          ),
        ),
      ),
    );
  }
}
