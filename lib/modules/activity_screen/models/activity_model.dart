class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String status;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: json['date'],
        time: json['time'],
        status: json['status']);
  }
}
