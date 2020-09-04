
class CartModel {
  String productName;
  String mediauri;
  int cartQnty;
  int price;
  int totalprice;

  CartModel(
      {this.productName,
      this.mediauri,
      this.cartQnty,
      this.price,
      this.totalprice});

  CartModel.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    mediauri = json['mediauri'];
    cartQnty = json['cart_qnty'];
    price = json['price'];
    totalprice = json['totalprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['mediauri'] = this.mediauri;
    data['cart_qnty'] = this.cartQnty;
    data['price'] = this.price;
    data['totalprice'] = this.totalprice;
    return data;
  }
}
