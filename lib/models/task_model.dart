class TaskModel {
  int? task_id;
  String? task_name;
  String? task_desc;
  int? task_state;
  String? expiration_date;
  String? alert_date;
  int? teacher_id;

  TaskModel(
      {this.task_id,
      this.task_name,
      this.task_desc,
      this.task_state,
      this.expiration_date,
      this.alert_date,
      this.teacher_id});

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        task_id: map['task_id'],
        task_name: map['task_name'],
        task_desc: map['task_desc'],
        task_state: map['task_state'],
        expiration_date: map['expiration_date'],
        alert_date: map['alert_date'],
        teacher_id: map['teacher_id']);
  }

}
