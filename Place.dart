class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.latitude, required this.longitude});
}

List<Place> places = [
  Place(name: "장소 1", latitude: 37.7749, longitude: -122.4194),
  Place(name: "장소 2", latitude: 34.0522, longitude: -118.2437),
  // 이 리스트에 분리수거 위치 추가하면 됨
];
