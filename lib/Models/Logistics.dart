class Logistics {
  int logId;
  double pricePerKm;
  String durationPerKm;
  String logisticName;
  Address address;
  ExceptionsIn exceptionsIn;

  Logistics(
      {this.logId,
      this.pricePerKm,
      this.durationPerKm,
      this.logisticName,
      this.address,
      this.exceptionsIn});

  factory Logistics.fromJson(Map<String, dynamic> json) {
    return Logistics(
      logId: json['logId'],
      pricePerKm: json['pricePerkm'],
      durationPerKm: json['durationPerKm'],
      logisticName: json['logisticName'],
      address: json['address'] != null
          ? new Address.fromJson(json['address'])
          : null,
      exceptionsIn: json['exceptionsIn'] != null
          ? new ExceptionsIn.fromJson(json['exceptionsIn'])
          : null,
    );
  }
}

class Address {
  String name;
  String zipcode;
  Geo geo;
  Address({this.name, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      zipcode: json['zipcode'],
      geo: json['geo'] != null ? new Geo.fromJson(json['geo']) : null,
    );
  }
}

class Geo {
  double lat;
  double lng;

  Geo({
    this.lat,
    this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class ExceptionsIn {
  OutsideTown outsideTown;
  OutsideCountry outsideCountry;

  ExceptionsIn({
    this.outsideCountry,
    this.outsideTown,
  });

  factory ExceptionsIn.fromJson(Map<String, dynamic> json) {
    return ExceptionsIn(
      outsideCountry: json['outsideCountry'] != null
          ? new OutsideCountry.fromJson(json['outsideCountry'])
          : null,
      outsideTown: json['outsideTown'] != null
          ? new OutsideTown.fromJson(json['outsideTown'])
          : null,
    );
  }
}

class OutsideCountry {
  double pricePerKm;
  String durationPerKm;

  OutsideCountry({
    this.durationPerKm,
    this.pricePerKm,
  });

  factory OutsideCountry.fromJson(Map<String, dynamic> json) {
    return OutsideCountry(
      pricePerKm: json['pricePerKm'],
      durationPerKm: json['durationPerKm'],
    );
  }
}

class OutsideTown {
  double pricePerKm;
  String durationPerKm;

  OutsideTown({
    this.durationPerKm,
    this.pricePerKm,
  });

  factory OutsideTown.fromJson(Map<String, dynamic> json) {
    return OutsideTown(
      pricePerKm: json['pricePerKm'],
      durationPerKm: json['durationPerKm'],
    );
  }
}
