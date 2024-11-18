class HistoryModel {
  final String conditionText;
  final String iconUrl;
  final String temperature;
  final String wind;
  final String humidity;
  final String time;

  HistoryModel({
    required this.time,
    required this.conditionText,
    required this.iconUrl,
    required this.temperature,
    required this.wind,
    required this.humidity,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      time: json['time'],
      conditionText: json['condition']['text'],
      iconUrl: json['condition']['icon'],
      temperature: '${json['temp_c']}°C',
      wind: '${json['maxwind_kph']} kph',
      humidity: '${json['avghumidity']}%',
    );
  }
}
