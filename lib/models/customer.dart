class Customer {
  String? customerId;
  String? customerName;
  int? customerContactNo;
  String? customerAddress;

  Customer(
      {this.customerId,
      this.customerName,
      this.customerContactNo,
      this.customerAddress});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_contact_no'] = customerContactNo;
    data['customer_address'] = customerAddress;
    return data;
  }

 fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerContactNo = json['customerContactNo'];
    customerAddress = json['customerAddress'];
  }

}
