class Customer {
  // String? customerId;
  String? registrationNo;
  String? customerName;
  int? customerContactNo;
  String? customerAddress;

  Customer(
      {
      // this.customerId,
      this.registrationNo,
      this.customerName,
      this.customerContactNo,
      this.customerAddress});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['customer_id'] = customerId;
    data['registration_no'] = registrationNo;
    data['customer_name'] = customerName;
    data['customer_contact_no'] = customerContactNo;
    data['customer_address'] = customerAddress;
    return data;
  }

  Customer.fromJson(Map<String, dynamic> json) {
    // customerId = json['customer_id'];
    registrationNo = json['registration_no'];
    customerName = json['customer_name'];
    customerContactNo = json['customer_contact_no'];
    customerAddress = json['customer_address'];
  }
}
