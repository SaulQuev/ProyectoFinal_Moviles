import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/class_model.dart';
import 'package:proyecto_moviles/models/teacher_model.dart';
import 'package:proyecto_moviles/screens/add_teacher_screen.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

Widget teacherWidget(TeacherModel teacher, BuildContext context) {
  Agenda? agendadb = Agenda();
  return FutureBuilder(
      future: agendadb.GETCLASS(teacher.class_id!),
      builder: (BuildContext context, AsyncSnapshot<ClassModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.teacher_name!,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(snapshot.data!.class_name!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 12))
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTeacherScreen(
                                        teacherModel: teacher,
                                      )));
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 40,
                      child: ElevatedButton(
                          onPressed: () async {
                            ArtDialogResponse response =
                                await ArtSweetAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                        denyButtonText: "Cancel",
                                        title: "Are you sure?",
                                        confirmButtonText: "Yes",
                                        type: ArtSweetAlertType.warning));

                            if (response.isTapConfirmButton) {
                              var res = await agendadb.DELETE('teachers',
                                  'teacher_id', teacher.teacher_id!, 'tasks');
                              if (res == 0) {
                                ArtSweetAlert.show(
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                        type: ArtSweetAlertType.danger,
                                        title: "¡Error!",
                                        text:
                                            "There are tasks which are registered with this teacher"));
                              }
                              GlobalValues.flag_database.value =
                                  !GlobalValues.flag_database.value;
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: const Icon(
                            Icons.delete,
                            size: 14,
                          )),
                    )
                  ],
                )
              ],
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something Was Wrong"),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      });
}
