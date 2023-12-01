import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/class_model.dart';
import 'package:proyecto_moviles/screens/add_class_screen.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

Widget classWidget(ClassModel class1, BuildContext context) {
  Agenda? agendadb = Agenda();

  return Container(
    margin: const EdgeInsets.only(bottom: 5),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
            color: Colors.white, // Color de fondo del contenedor
            borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
      ),
    child: Row(
      children: [
        Column(
          children: [
            Text(
              class1.class_name!,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black,),
            ),
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
                          builder: (context) => AddClassScreen(
                                classModel: class1,
                              )));
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
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
                    ArtDialogResponse response = await ArtSweetAlert.show(
                        barrierDismissible: false,
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                            denyButtonText: "Cancel",
                            title: "Are you sure?",
                            confirmButtonText: "Yes",
                            type: ArtSweetAlertType.warning));

                    if (response.isTapConfirmButton) {
                      var res = await agendadb.DELETE('class', 'class_id',
                          class1.class_id!, 'teachers');
                      if (res == 0) {
                        ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.danger,
                                title: "¡Error!",
                                text:
                                    "There are teachers who are registered with this class"));
                      }
                      GlobalValues.flag_database.value =
                          !GlobalValues.flag_database.value;
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
}
