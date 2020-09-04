class CustomerOrder {
  String orderId;
  String paymentMethod;
  Cart cart;
  ShippingInfo shippingInfo;

  CustomerOrder({this.orderId, this.paymentMethod, this.cart, this.shippingInfo});

  CustomerOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    paymentMethod = json['payment_method'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    shippingInfo = json['shipping_info'] != null
        ? new ShippingInfo.fromJson(json['shipping_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['payment_method'] = this.paymentMethod;
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    if (this.shippingInfo != null) {
      data['shipping_info'] = this.shippingInfo.toJson();
    }
    return data;
  }
}

class Cart {
  int cartQnty;
  double totalPrice;
  Product product;

  Cart({this.cartQnty, this.totalPrice, this.product});

  Cart.fromJson(Map<String, dynamic> json) {
    cartQnty = json['cart_qnty'];
    totalPrice = json['total_price'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_qnty'] = this.cartQnty;
    data['total_price'] = this.totalPrice;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  String name;

  Product({this.name});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class ShippingInfo {
  String customerName;
  String contact;
  String townCity;
  bool delivery;

  ShippingInfo({this.customerName, this.contact, this.townCity, this.delivery});

  ShippingInfo.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    contact = json['contact'];
    townCity = json['town_city'];
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['contact'] = this.contact;
    data['town_city'] = this.townCity;
    data['delivery'] = this.delivery;
    return data;
  }
}
