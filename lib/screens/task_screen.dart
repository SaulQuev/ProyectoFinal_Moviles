import 'dart:math';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/task_model.dart';
import 'package:proyecto_moviles/provider/notification_provider.dart';
import 'package:proyecto_moviles/styles/global_values.dart';
import 'package:proyecto_moviles/widgets/TaskWidget.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Agenda? agendadb;
  TextEditingController searchController = TextEditingController();
  String? dropValueState = "Todas";
  List<String>? dropStateValues = ["Sin Completar", "Completada", "Todas"];

  @override
  void initState() {
    super.initState();
    agendadb = Agenda();
    NotificationProvider.initialize();
    notifyNearTasks();
  }

  Future deleteAll() async {
    agendadb!.DELETEALL('tasks');
  }

  Future<void> notifyNearTasks() async {
    var res = await agendadb!.GETUNFINISHEDTASKS();
    var today = DateTime.now();
    var tomorrowTasks = 0;
    for (var element in res) {
      var task = DateTime.parse(element.alert_date!);
      if (task.year == today.year &&
          task.month == today.month &&
          task.day == today.day) {
        tomorrowTasks++;
      }
    }
    if (tomorrowTasks != 0) {
      NotificationProvider.showBigTextNotification(
        title: "Alert!",
        body: tomorrowTasks != 1
            ? "You have $tomorrowTasks pending tasks for tomorrow"
            : "You have $tomorrowTasks pending task for tomorrow",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DropdownButton dropDownButtonStates = DropdownButton(
        value: dropValueState,
        items: dropStateValues
            ?.map((state) => DropdownMenuItem(value: state, child: Text(state)))
            .toList(),
        onChanged: (value) {
          dropValueState = value;
          setState(() {});
        });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador de Tareas'),
        actions: [
          IconButton(
              onPressed: () async {
                var res = await agendadb!.GETALLTEACHERS();
                if (res.isEmpty) {
                  ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
                          title: "¡Debe insertar profe!",
                          text:
                              "Registra por lo menos un profesor para agregar tareas"));
                } else {
                  Navigator.pushNamed(context, '/addTask');
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: GlobalValues.flag_database,
          builder: (context, value, _) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Buscar...",
                          ),
                          controller: searchController,
                          onChanged: (text) {
                            GlobalValues.flag_database.value =
                                !GlobalValues.flag_database.value;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      dropDownButtonStates
                    ],
                  ),
                ),
                Flexible(
                  child: FutureBuilder(
                      future: dropValueState != "Todas"
                          ? agendadb!.GETFILTEREDTASKS(searchController.text,
                              dropValueState == "Completada" ? 1 : 0)
                          : agendadb!.GETFILTEREDTASKS(searchController.text,
                              null), //PROGRAMAR FILTRO ALL
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TaskModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: taskWidget(
                                      snapshot.data![index], context),
                                  onTap: () {
                                
                                    
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(3, 5),
                                                    blurRadius: 10)
                                              ]),
                                          padding: const EdgeInsets.all(10),
                                          child: Card(
                                            // Define the shape of the card
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            // Define how the card's content should be clipped
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            // Define the child widget of the card
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Add padding around the row widget
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Add an image widget to display an image
                                                      // Add some spacing between the image and the text
                                                      Container(width: 20),
                                                      // Add an expanded widget to take up the remaining horizontal space
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Add some spacing between the top of the card and the title
                                                            Container(
                                                                height: 5),
                                                            // Add a title widget
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .task_name!,
                                                              style: MyTextSample
                                                                      .title(
                                                                          context)!
                                                                  .copyWith(
                                                                color:
                                                                    MyColorsSample
                                                                        .grey_80,
                                                              ),
                                                            ),
                                                            // Add some spacing between the title and the subtitle
                                                            Container(
                                                                height: 5),
                                                            // Add a subtitle widget
                                                            Text(
                                                              "Expires: ${snapshot.data![index].expiration_date!}",
                                                              style: MyTextSample
                                                                      .body1(
                                                                          context)!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                            ),
                                                            // Add some spacing between the subtitle and the text
                                                            Container(
                                                                height: 10),
                                                            // Add a text widget to display some text
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshot.data![index]
                                                                              .task_state! ==
                                                                          0
                                                                      ? "Sin Completar"
                                                                      : "Completada",
                                                                  maxLines: 2,
                                                                  style: MyTextSample
                                                                          .subhead(
                                                                              context)!
                                                                      .copyWith(
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                snapshot.data![index]
                                                                            .task_state! ==
                                                                        1
                                                                    ? const Icon(
                                                                        Icons
                                                                            .check_circle_outline_outlined,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    snapshot.data![index]
                                                        .task_desc!,
                                                    maxLines: 2,
                                                    style: MyTextSample.subhead(
                                                            context)!
                                                        .copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              });
                        } else {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Something Was Wrong'),
                            );
                          } else {
                            return const Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 60,
                                  child: CircularProgressIndicator()),
                            );
                          }
                        }
                      }),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/calendar');
        },
        child: const Icon(Icons.calendar_month_outlined),
      ),
    );
  }
}

class MyColorsSample {
  static const Color primary = Color(0xFF12376F);
  static const Color primaryDark = Color(0xFF0C44A3);
  static const Color primaryLight = Color(0xFF43A3F3);
  static const Color green = Colors.green;
  static Color black = const Color(0xFF000000);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);
  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
  static const Color transparent = Color(0x00f7f7f7);
}

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}
