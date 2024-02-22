import 'dart:convert';

class DomainModel {
  String? context;
  String? id;
  String? type;
  int? hydraTotalItems;
  List<HydraMember>? hydraMember;

  DomainModel({
    this.context,
    this.id,
    this.type,
    this.hydraTotalItems,
    this.hydraMember,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) => DomainModel(
    context: json["@context"],
    id: json["@id"],
    type: json["@type"],
    hydraTotalItems: json["hydra:totalItems"],
    hydraMember: json["hydra:member"] == null
        ? []
        : List<HydraMember>.from(
        json["hydra:member"].map((x) => HydraMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "@context": context,
    "@id": id,
    "@type": type,
    "hydra:totalItems": hydraTotalItems,
    "hydra:member": hydraMember == null
        ? []
        : List<dynamic>.from(hydraMember!.map((x) => x.toJson())),
  };
}

class HydraMember {
  String? id;
  String? type;
  String? domain;
  bool? isActive;
  bool? isPrivate;
  DateTime? createdAt;
  DateTime? updatedAt;

  HydraMember({
    this.id,
    this.type,
    this.domain,
    this.isActive,
    this.isPrivate,
    this.createdAt,
    this.updatedAt,
  });

  factory HydraMember.fromJson(Map<String, dynamic> json) => HydraMember(
    id: json["@id"],
    type: json["@type"],
    domain: json["domain"],
    isActive: json["isActive"],
    isPrivate: json["isPrivate"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "@id": id,
    "@type": type,
    "domain": domain,
    "isActive": isActive,
    "isPrivate": isPrivate,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

void main() {
  String jsonString = '''
    {
      "@context": "/contexts/Domain",
      "@id": "/domains",
      "@type": "hydra:Collection",
      "hydra:totalItems": 1,
      "hydra:member": [
        {
          "@id": "/domains/65cb1c958317a98ed419ba2c",
          "@type": "Domain",
          "id": "65cb1c958317a98ed419ba2c",
          "domain": "puabook.com",
          "isActive": true,
          "isPrivate": false,
          "createdAt": "2024-02-13T00:00:00+00:00",
          "updatedAt": "2024-02-13T00:00:00+00:00"
        }
      ]
    }
  ''';

  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  DomainModel domainModel = DomainModel.fromJson(jsonData);
  print(domainModel.toJson());
}
