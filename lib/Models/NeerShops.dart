

class NeerShops {
  final String id;
  final String shopname;
  final String geocode;
  final String description;
  final String rating;
  final String imgUrl;

  NeerShops(
      this.id,
      this.shopname,
      this.geocode,
      this.description,
      this.rating,
      this.imgUrl);

  // factory NeerShops.fromJson(Map<String, dynamic> json) {
  //   return NeerShops(
  //     id: json['id'],
  //     shopname: json['name'],
  //     description: json['description'],
  //     geocode: json['geocode'],
  //     rating: json['rating'],
  //     imgUrl: json['imgUrl'],
  //   );
  // }
}
