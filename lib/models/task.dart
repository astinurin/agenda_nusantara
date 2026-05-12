class Task {
  int? id;
  String judul;
  String deskripsi;
  String tanggal;
  bool isPenting;
  bool isSelesai;
  String? tanggalSelesai;

  Task({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.isPenting,
    this.isSelesai = false,
    this.tanggalSelesai,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'isPenting': isPenting ? 1 : 0,
      'isSelesai': isSelesai ? 1 : 0,
      'tanggalSelesai': tanggalSelesai,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      tanggal: map['tanggal'],
      isPenting: map['isPenting'] == 1,
      isSelesai: map['isSelesai'] == 1,
      tanggalSelesai: map['tanggalSelesai'],
    );
  }
}
