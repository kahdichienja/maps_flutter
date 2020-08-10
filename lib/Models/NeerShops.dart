class UserShopInfo {
  int id;
  String name;

  String username;
  String email, profileUrl;
  Address address;
  String phone;
  String website;
  Company company;

  UserShopInfo(
      {this.id,
      this.name,
      this.username,
      this.profileUrl = 'https://avatars2.githubusercontent.com/u/37832937?s=400&u=f4e9a84c795005decc9955ed7882589eadb26994&v=4',
      this.email,
      this.address,
      this.phone,
      this.website,
      this.company});

  factory UserShopInfo.fromJson(Map<String, dynamic> json) {
    return UserShopInfo(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: json['address'] != null
          ? new Address.fromJson(json['address'])
          : null,
      phone: json['phone'],
      website: json['website'],
      company: json['company'] != null ? new Company.fromJson(json['company']) : null,
    );
  }

}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: json['geo'] != null ? new Geo.fromJson(json['geo']) : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['street'] = this.street;
  //   data['suite'] = this.suite;
  //   data['city'] = this.city;
  //   data['zipcode'] = this.zipcode;
  //   if (this.geo != null) {
  //     data['geo'] = this.geo.toJson();
  //   }
  //   return data;
  // }
}

class Geo {
  String lat;
  String lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['lat'] = this.lat;
  //   data['lng'] = this.lng;
  //   return data;
  // }
}

class Company {
  String name;
  String catchPhrase;
  String bs;

  Company({this.name, this.catchPhrase, this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = this.name;
  //   data['catchPhrase'] = this.catchPhrase;
  //   data['bs'] = this.bs;
  //   return data;
  // }
}
