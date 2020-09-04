class MerchantShop {
  int id;
  String shopName;
  Address address;
  ShopProduct shopProduct;

  MerchantShop({this.id, this.shopName, this.address, this.shopProduct});

  MerchantShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    shopProduct = json['shop_product'] != null
        ? new ShopProduct.fromJson(json['shop_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.shopProduct != null) {
      data['shop_product'] = this.shopProduct.toJson();
    }
    return data;
  }
}

class Address {
  String addresName;
  String cityOrTown;
  Location location;

  Address({this.addresName, this.cityOrTown, this.location});

  Address.fromJson(Map<String, dynamic> json) {
    addresName = json['addres_name'];
    cityOrTown = json['city_or_town'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addres_name'] = this.addresName;
    data['city_or_town'] = this.cityOrTown;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class ShopProduct {
  int id;
  String name;
  String mediaUrl;
  int price;
  String comments;
  int rating;

  ShopProduct(
      {this.id,
      this.name,
      this.mediaUrl,
      this.price,
      this.comments,
      this.rating});

  ShopProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mediaUrl = json['media_url'];
    price = json['price'];
    comments = json['comments'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['media_url'] = this.mediaUrl;
    data['price'] = this.price;
    data['comments'] = this.comments;
    data['rating'] = this.rating;
    return data;
  }
}
