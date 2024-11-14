class ForecastDay {
  final String date;
  final String temperature;
  final String wind;
  final String humidity;
  final String iconUrl;

  ForecastDay({
    required this.date,
    required this.temperature,
    required this.wind,
    required this.humidity,
    required this.iconUrl,
  });

  // Phương thức để tạo ForecastDay từ JSON
  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      temperature: '${json['day']['maxtemp_c']}°C',
      wind: '${json['day']['maxwind_kph']} kph',
      humidity: '${json['day']['avghumidity']}%',
      iconUrl: json['day']['condition']['icon'],
    );
  }
}
