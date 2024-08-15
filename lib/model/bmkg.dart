class ModelBmkg {
  ModelBmkg({
    required this.infogempa,
  });

  final Infogempa? infogempa;

  factory ModelBmkg.fromJson(Map<String, dynamic> json) {
    return ModelBmkg(
      infogempa: json["Infogempa"] == null
          ? null
          : Infogempa.fromJson(json["Infogempa"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Infogempa": infogempa?.toJson(),
      };
}

class Infogempa {
  Infogempa({
    required this.gempa,
  });

  final List<Gempa> gempa;

  factory Infogempa.fromJson(Map<String, dynamic> json) {
    return Infogempa(
      gempa: json["gempa"] == null
          ? []
          : List<Gempa>.from(json["gempa"]!.map((x) => Gempa.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "gempa": gempa.map((x) => x.toJson()).toList(),
      };
}

class Gempa {
  Gempa({
    required this.tanggal,
    required this.jam,
    required this.dateTime,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
  });

  final String? tanggal;
  final String? jam;
  final DateTime? dateTime;
  final String? coordinates;
  final String? lintang;
  final String? bujur;
  final String? magnitude;
  final String? kedalaman;
  final String? wilayah;
  final String? potensi;

  factory Gempa.fromJson(Map<String, dynamic> json) {
    return Gempa(
      tanggal: json["Tanggal"],
      jam: json["Jam"],
      dateTime: DateTime.tryParse(json["DateTime"] ?? ""),
      coordinates: json["Coordinates"],
      lintang: json["Lintang"],
      bujur: json["Bujur"],
      magnitude: json["Magnitude"],
      kedalaman: json["Kedalaman"],
      wilayah: json["Wilayah"],
      potensi: json["Potensi"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Tanggal": tanggal,
        "Jam": jam,
        "DateTime": dateTime?.toIso8601String(),
        "Coordinates": coordinates,
        "Lintang": lintang,
        "Bujur": bujur,
        "Magnitude": magnitude,
        "Kedalaman": kedalaman,
        "Wilayah": wilayah,
        "Potensi": potensi,
      };
}
