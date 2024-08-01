import 'package:dms/inits/init.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? make;
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
      this.make,
      this.varient,
      this.color,
      this.kms,
      this.customerNumber,
      this.cusotmerName,
      this.customerPhoneNumber,
      this.vehicleRegNumber,
      this.mfgYear,
      this.financialDetails,
      this.insuranceCompany,
      this.engineNumber,
      this.customerContactNo,
      this.customerName,
      this.customerAddress});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    chassisNumber = json['chassis_no'];
    model = json['model'];
    kms = json['kms'];
    make = json['make'];
    engineNumber = json["engine_no"];
    customerNumber = json['customerNumber'];
    cusotmerName = json['customer_name'];
    varient = json['variant'];
    color = json['color'];
    vehicleRegNumber = json['vehicle_registration_no'];
    mfgYear = json['mfg_year'];
    financialDetails = json['financial_details'];
    insuranceCompany = json['insurance_company'];
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
    data['make'] = make;
    data['engine_no'] = engineNumber;
    data['make'] = make;
    data['variant'] = varient;
    data['color'] = color;
    data['customer_name'] = cusotmerName;
    data['vehicle_registration_no'] = vehicleRegNumber;
    data['mfg_year'] = mfgYear;
    data['financial_details'] = financialDetails;
    data['insurance_company'] = insuranceCompany;
    data['customer_contact_no'] = customerContactNo;
    data['customer_name'] = customerName;
    data['customer_address'] = customerAddress;
    data['employee_id'] =
        getIt<SharedPreferences>().getInt('service_advisor_id');
    return data;
  }
}
