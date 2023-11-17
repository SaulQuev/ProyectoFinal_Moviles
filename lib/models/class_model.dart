class ClassModel {
  int? class_id;
  String? class_name;

  ClassModel({this.class_id, this.class_name});

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
        class_id: map['class_id'], class_name: map['class_name']);
  }
}
