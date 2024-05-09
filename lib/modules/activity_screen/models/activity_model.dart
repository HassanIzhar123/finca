class ActivityModel {
  final String activityId;
  final String farmName;
  final String cropName;
  final String activityType;
  final DateTime startDate;
  final DateTime endDate;
  final String? chemicalName;
  final String? details;
  final double? amount;
  final hasData = true;
  final bool isAllDay;

  ActivityModel({
    required this.activityId,
    required this.farmName,
    required this.cropName,
    required this.activityType,
    required this.startDate,
    required this.endDate,
    this.chemicalName,
    this.details,
    this.amount,
    this.isAllDay = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'farmName': farmName,
      'cropName': cropName,
      'activityType': activityType,
      'startDate': startDate.toLocal(),
      'endDate': endDate.toLocal(),
      'chemicalName': chemicalName,
      'details': details,
      'amount': amount,
      'isAllDay': isAllDay,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      activityId: map['activityId'],
      farmName: map['farmName'],
      cropName: map['cropName'],
      activityType: map['activityType'],
      startDate: (map['startDate'].toDate() as DateTime).toLocal(),
      endDate: (map['endDate'].toDate() as DateTime).toLocal(),
      chemicalName: map['chemicalName'],
      details: map['details'],
      amount: map['amount'],
      isAllDay: map['isAllDay'] ?? false,
    );
  }

  @override
  String toString() {
    return 'ActivityModel(activityId: $activityId, farmName: $farmName, cropName: $cropName, activityType: $activityType, startDate: $startDate, endDate: $endDate, chemicalName: $chemicalName, details: $details, amount: $amount)';
  }
}
