class ModelBmkg {
  ModelBmkg({
    this.infogempa,
  });

  Infogempa? infogempa;

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
    this.gempa,
  });

  List<Gempa>? gempa;

  factory Infogempa.fromJson(Map<String, dynamic> json) {
    return Infogempa(
      gempa: json["gempa"] == null
          ? []
          : List<Gempa>.from(json["gempa"]!.map((x) => Gempa.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "gempa": gempa?.map((x) => x.toJson()).toList(),
      };
}

class Gempa {
  Gempa({
    this.tanggal,
    this.jam,
    this.dateTime,
    this.coordinates,
    this.lintang,
    this.bujur,
    this.magnitude,
    this.kedalaman,
    this.wilayah,
    this.potensi,
  });

  String? tanggal;
  String? jam;
  DateTime? dateTime;
  String? coordinates;
  String? lintang;
  String? bujur;
  String? magnitude;
  String? kedalaman;
  String? wilayah;
  String? potensi;

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
