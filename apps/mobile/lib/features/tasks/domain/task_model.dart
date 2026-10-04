class TaskModel {
  final String id;
  final String title;
  final String? description;
  final int budgetPaise;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;
  final String status;
  final String? categoryName;
  final String? categoryIcon;
  final String? imageUrl;
  final String? scheduledDate;
  final String? creatorName;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.budgetPaise,
    this.latitude,
    this.longitude,
    this.locationLabel,
    required this.status,
    this.categoryName,
    this.categoryIcon,
    this.imageUrl,
    this.scheduledDate,
    this.creatorName,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      budgetPaise: (json['budget_paise'] as num?)?.toInt() ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationLabel: json['location_label'] as String?,
      status: json['status'] as String? ?? 'OPEN',
      categoryName: json['category_name'] as String?,
      categoryIcon: json['category_icon'] as String?,
      imageUrl: json['image_url'] as String?,
      scheduledDate: json['scheduled_date'] as String?,
      creatorName: json['creator_name'] as String?,
    );
  }

  String get budgetDisplay => '₹${(budgetPaise / 100).toStringAsFixed(0)}';
}
