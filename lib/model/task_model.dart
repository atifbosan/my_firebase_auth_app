class TaskModel {
  String? id;
  String? title;
  String? description;
  String? date;
  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date});
  static TaskModel fronJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date']);
}
