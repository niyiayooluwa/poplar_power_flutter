class TimestampsDto {
  final int createdAt;
  final int updatedAt;

  TimestampsDto({required this.createdAt, required this.updatedAt});

  factory TimestampsDto.fromJson(Map<String, dynamic> json) {
    return TimestampsDto(
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }
}
