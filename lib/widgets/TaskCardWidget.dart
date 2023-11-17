import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/task_model.dart';
import 'package:proyecto_moviles/screens/add_task_screen.dart';
import 'package:proyecto_moviles/styles/global_values.dart';

class TaskCardWidget extends StatelessWidget {
  TaskCardWidget({super.key, required this.taskModel, this.agendadb});

  TaskModel taskModel;
  Agenda? agendadb;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.green),
      child: Row(
        children: [
          Column(
            children: [
              Text(taskModel.task_name!),
              Text(taskModel.task_desc!),
              Text('${taskModel.task_state!}'),
              Text(taskModel.expiration_date!),
              Text(taskModel.alert_date!),
              Text('${taskModel.teacher_id!}')
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTaskScreen(
                              taskModel: taskModel,
                            ))),
                child: Image.asset(
                  'assets/images/four_sword.png',
                  height: 50,
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('System Message'),
                            content:
                                const Text('¿Do you want to delete this task?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    agendadb!
                                        .DELETE('tasks', 'task_id',
                                            taskModel.task_id!, null)
                                        .then((value) {
                                      Navigator.pop(context);
                                      GlobalValues.flag_database.value =
                                          !GlobalValues.flag_database.value;
                                    });
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete))
            ],
          )
          //Column()
        ],
      ),
    );
  }
}
