class Appliance {
  final String id;
  final String name;
  final double powerWatts;
  final double hoursUsedPerDay;

  Appliance({
    required this.id,
    required this.name,
    required this.powerWatts,
    required this.hoursUsedPerDay,
  });

  Appliance copyWith({
    String? name,
    double? powerWatts,
    double? hoursUsedPerDay,
  }) {
    return Appliance(
      id: this.id,
      name: name ?? this.name,
      powerWatts: powerWatts ?? this.powerWatts,
      hoursUsedPerDay: hoursUsedPerDay ?? this.hoursUsedPerDay,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'powerWatts': powerWatts,
        'hoursUsedPerDay': hoursUsedPerDay,
      };

  factory Appliance.fromJson(Map<String, dynamic> json) => Appliance(
        id: json['id'],
        name: json['name'],
        powerWatts: (json['powerWatts'] as num).toDouble(),
        hoursUsedPerDay: (json['hoursUsedPerDay'] as num).toDouble(),
      );

  double get dailyEnergyKwh => (powerWatts * hoursUsedPerDay) / 1000;
}