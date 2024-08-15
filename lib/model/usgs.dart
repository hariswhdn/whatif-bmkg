class ModelUsgs {
  List<Feature>? features;

  ModelUsgs({
    this.features,
  });

  factory ModelUsgs.fromJson(Map<String, dynamic> json) {
    return ModelUsgs(
      features: json["features"] == null
          ? []
          : List<Feature>.from(
              json["features"]?.map((x) => Feature.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "features": features?.map((x) => x.toJson()).toList(),
      };
}

class Feature {
  Feature({
    this.properties,
    this.geometry,
  });

  Properties? properties;
  Geometry? geometry;

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      properties: Properties.fromJson(json["properties"]),
      geometry: Geometry.fromJson(json["geometry"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "properties": properties?.toJson(),
        "geometry": geometry?.toJson(),
      };
}

class Geometry {
  Geometry({
    this.coordinates,
  });

  List<double>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(json["coordinates"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates?.toList(),
      };
}

class Properties {
  Properties({
    this.mag,
    this.place,
    this.time,
    this.tsunami,
  });

  double? mag;
  String? place;
  int? time;
  int? tsunami;

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      mag: json["mag"],
      place: json["place"],
      time: json["time"],
      tsunami: json["tsunami"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mag": mag,
        "place": place,
        "time": time,
        "tsunami": tsunami,
      };
}
