class DashboardModel {
  final String username;

  DashboardModel({required this.username});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      username: json['name'] ?? '',
    );
  }
}
