class PlayList {
  int id;
  String title;
  String? photo_68;
  String? photo_135;
  String? photo_300;
  PlayList({
    required this.id,
    required this.title,
    required this.photo_68,
    required this.photo_135,
    required this.photo_300,
  });

  factory PlayList.fromMap(Map<String, dynamic> map) {
    return PlayList(
      id: map['id'] as int,
      title: map['title'] as String,
      photo_68: map['photo']?['photo_68'].toString(),
      photo_135: map['photo']?['photo_135'].toString(),
      photo_300: map['photo']?['photo_300'].toString(),
    );
  }
}
