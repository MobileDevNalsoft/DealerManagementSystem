
class Vehicle {
  String? vehicleType;
  String? chassisNumber;
  String? model;
  int? kms;
  String? customerNumber;
  String? cusotmerName;
  int? customerPhoneNumber;
  String? vehicleRegNumber;
  String? engineNumber;
  String? varient;
  String? color;
  int? mfgYear;
  String? make;
  String? financialDetails;
  String? insuranceCompany;
  String? customerAddress;


  Vehicle(
      {this.vehicleType,
      this.chassisNumber,
      this.model,
      this.kms,
      this.customerNumber,
      this.cusotmerName,
      this.customerPhoneNumber,
      this.vehicleRegNumber,
      this.mfgYear,
      this.make,
      this.financialDetails,
      this.insuranceCompany,
      this.customerAddress, 
      this.engineNumber});

Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicleType'];
    chassisNumber = json['chassisNumber'];
    model = json['model'];
    kms = json['kms'];
    make = json['make'];
    engineNumber= json["engine_no"];
    customerNumber = json['customerNumber'];
    cusotmerName = json['customer_name'];
    varient = json['varient'];
    color = json['color'];
    // customerPhoneNumber = json['customerPhoneNumber'];
    vehicleRegNumber = json['vehicle_registration_no'];
    mfgYear = json['mfg_year'];
    financialDetails = json['financial_details'];
    insuranceCompany = json['insuranceCompany'];
    // customerAddress = json['customerAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['vehicle_type'] = vehicleType;
    data['chassis_no'] = chassisNumber;
    data['model'] = model;
    data['kms'] = kms;
    data['make'] = make;
    data['engine_no'] = engineNumber;
    data['varient'] = varient;
    data['color'] = color;
    data['customer_no'] = customerNumber;
    data['customer_name'] = cusotmerName;
    // data['customerPhoneNumber'] = customerPhoneNumber;
    data['vehicle_registration_no'] = vehicleRegNumber;
    data['mfg_year'] = mfgYear;
    data['financial_details'] = financialDetails;
    data['insurance_company'] = insuranceCompany;
    // data['customerAddress'] = customerAddress;
    return data;
  } 
}