import 'package:dms/inits/init.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Service {
  int? sNo;
  String? registrationNo;
  String? jobCardNo;
  String? serviceBookingNo;
  String? location;
  String? customerName;
  String? scheduledDate;
  int? kms;
  String? bookingSource;
  String? alternateContactPerson;
  int? alternatePersonContactNo;
  String? salesPerson;
  String? bay;
  String? jobType;
  String? customerConcerns;
  String? remarks;
  String? status;
  String? customerContact;
  String? creationDate;

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  Service(
      {this.sNo,
      this.registrationNo,
      this.jobCardNo,
      this.serviceBookingNo,
      this.location,
      this.customerName,
      this.customerContact,
      this.scheduledDate,
      this.kms,
      this.bookingSource,
      this.alternateContactPerson,
      this.alternatePersonContactNo,
      this.salesPerson,
      this.bay,
      this.jobType,
      this.status,
      this.customerConcerns,
      this.creationDate,
      this.remarks});

  factory Service.initial() {
    return Service(
        location: '',
        alternateContactPerson: '',
        alternatePersonContactNo: 0,
        bay: '',
        bookingSource: '',
        creationDate: '',
        customerConcerns: '',
        customerContact: '',
        customerName: '',
        jobCardNo: '',
        jobType: '',
        kms: 0,
        registrationNo: '',
        remarks: '',
        sNo: 0,
        salesPerson: '',
        scheduledDate: '',
        status: '');
  }

  Service.fromJson(Map<String, dynamic> json) {
    registrationNo = json['vehicle_registration_number'];
    location = json['location'];
    customerName = json['customer_name'];
    customerContact = json['contact_no'];
    scheduledDate = json['scheduled_date'];
    kms = json['kms'];
    bookingSource = json['booking_source'];
    alternateContactPerson = json['alternate_contact_person'];
    alternatePersonContactNo = json['alternate_contact_person_contact_no'];
    salesPerson = json['user_name'];
    bay = json['bay'];
    jobType = json['job_type'];
    jobCardNo = json['job_card_no'];
    customerConcerns = json['customer_concerns'];
    status = json['status'];
    remarks = json['remarks'];
    creationDate = json['creation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_registration_no'] = registrationNo;
    data['location'] = location;
    data['customer_name'] = customerName;
    data['scheduled_date'] = scheduledDate;
    data['kms'] = kms;
    data['booking_source'] = bookingSource;
    data['alternate_contact_person'] = alternateContactPerson;
    data['alternate_person_contact_no'] = alternatePersonContactNo;
    data['user_name'] = sharedPreferences.getString('user_name');
    data['bay'] = bay;
    data['job_type'] = jobType;
    data['job_card_no'] = jobCardNo;
    data['customer_concerns'] = customerConcerns;
    data['remarks'] = remarks;
    return data;
  }

  Service copyWith(
      {String? registrationNo,
      String? location,
      String? customerName,
      String? scheduledDate,
      int? kms,
      String? bookingSource,
      String? alternateContactPerson,
      int? alternatePersonContactNo,
      String? salesPerson,
      String? bay,
      String? jobType,
      String? jobCardNo,
      String? serviceBookingNo,
      String? customerConcerns,
      String? remarks}) {
    return Service(
        registrationNo: registrationNo ?? this.registrationNo,
        location: location ?? this.location,
        customerName: customerName ?? this.customerName,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        kms: kms ?? this.kms,
        bookingSource: bookingSource ?? this.bookingSource,
        alternateContactPerson:
            alternateContactPerson ?? this.alternateContactPerson,
        alternatePersonContactNo:
            alternatePersonContactNo ?? this.alternatePersonContactNo,
        salesPerson: salesPerson ?? this.salesPerson,
        bay: bay ?? this.bay,
        jobType: jobType ?? this.jobType,
        jobCardNo: jobCardNo ?? this.jobCardNo,
        serviceBookingNo: serviceBookingNo ?? this.serviceBookingNo,
        customerConcerns: customerConcerns ?? this.customerConcerns,
        remarks: remarks ?? this.remarks);
  }
}
