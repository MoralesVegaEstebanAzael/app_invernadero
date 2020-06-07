import 'dart:convert';

Feature featureFromJson(String str) => Feature.fromJson(json.decode(str));

String featureToJson(Feature data) => json.encode(data.toJson());

class Feature {
    Feature({
        this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.text,
        this.placeName,
        this.center,
        this.geometry,
        this.context,
    });

    String id;
    String type;
    List<String> placeType;
    double relevance;
    Properties properties;
    String text;
    String placeName;
    List<double> center;
    Geometry geometry;
    List<Context> context;

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: json["context"]!=null? List<Context>.from(json["context"].map((x) => Context.fromJson(x))):List<Context>(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
    };
}

class Context {
    Context({
        this.id,
        this.text,
        this.wikidata,
        this.shortCode,
    });

    String id;
    String text;
    String wikidata;
    String shortCode;

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        text: json["text"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
    };
}

class Geometry {
    Geometry({
        this.type,
        this.coordinates,
    });

    String type;
    List<double> coordinates;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    Properties({
        this.accuracy,
    });

    String accuracy;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"],
    );

    Map<String, dynamic> toJson() => {
        "accuracy": accuracy,
    };
}