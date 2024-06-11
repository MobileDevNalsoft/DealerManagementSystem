class Vehicle {
  String? vehicleType;
  String? chassisNumber;
  String? model;
  int? kms;
  String? vehicleRegNumber;
  String? engineNumber;
  String? varient;
  String? color;
  int? mfgYear;
  String? financialDetails;
  String? insuranceCompany;
  String? customerContactNo;
  String? customerName;
  String? customerAddress;

  Vehicle(
      {this.vehicleType,
      this.chassisNumber,
      this.model,
      this.color,
      this.kms,
      this.vehicleRegNumber,
      this.mfgYear,
      this.financialDetails,
      this.insuranceCompany,
      this.engineNumber,
      this.customerContactNo,
      this.customerName,
      this.customerAddress});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicleType'];
    chassisNumber = json['chassisNumber'];
    model = json['model'];
    kms = json['kms'];
    engineNumber = json["engine_no"];
    varient = json['varient'];
    color = json['color'];
    vehicleRegNumber = json['vehicle_registration_no'];
    mfgYear = json['mfg_year'];
    financialDetails = json['financial_details'];
    insuranceCompany = json['insuranceCompany'];
    customerContactNo = json['customer_contact_no'];
    customerName = json['customer_name'];
    customerAddress = json['customer_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['vehicle_type'] = vehicleType;
    data['chassis_no'] = chassisNumber;
    data['model'] = model;
    data['kms'] = kms;
    data['engine_no'] = engineNumber;
    data['varient'] = varient;
    data['color'] = color;
    data['vehicle_registration_no'] = vehicleRegNumber;
    data['mfg_year'] = mfgYear;
    data['financial_details'] = financialDetails;
    data['insurance_company'] = insuranceCompany;
    data['customer_contact_no'] = customerContactNo;
    data['customer_name'] = customerName;
    data['customer_address'] = customerAddress;
    return data;
  }
}
