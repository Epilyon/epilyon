import 'package:epilyon/data.dart';

List<Task>? get tasks => data.tasks;

class Task {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? shortId;
  String? visibility;
  int? promotion;
  String? semester;
  String? region;
  String? title;
  String? subject;
  String? content;
  DateTime? dueDate;
  String? createdByLogin;
  String? createdBy;
  String? updatedByLogin;
  String? updatedBy;

  Task(
      this.createdAt,
      this.updatedAt,
      this.shortId,
      this.visibility,
      this.promotion,
      this.semester,
      this.region,
      this.title,
      this.subject,
      this.content,
      this.dueDate,
      this.createdByLogin,
      this.createdBy,
      this.updatedByLogin,
      this.updatedBy);
}
