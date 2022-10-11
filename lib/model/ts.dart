class TSModel {
  String keyURL;
  String fileURL;
  String duration;
  String name;
  TSModel({
    required this.keyURL,
    required this.fileURL,
    required this.duration,
    required this.name,
  });

  @override
  String toString() {
    return 'TSModel(keyURL: $keyURL, fileURL: $fileURL, duration: $duration, name: $name)';
  }
}
