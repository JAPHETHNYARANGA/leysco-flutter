class Task {
  final int id;
  final String name;
  final String status;
  final int userId;
  final String? assignedUser;
  final String createdAt;
  final String updatedAt;

  Task({
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
    required this.assignedUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      userId: json['user_id'],
      assignedUser: json['assigned_user'], // Cast to int? directly
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
