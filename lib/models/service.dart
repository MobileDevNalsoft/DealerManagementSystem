class Service {
  String? registrationNo;
  String? location;
  String? customerName;
  String? scheduleDate;
  int? kms;
  String? bookingSource;
  String? alternateContactPerson;
  int? alternatePersonContactNo;
  String? salesPerson;
  String? bay;
  String? jobType;
  String? customerConcerns;
  String? remarks;

  Service(
      {this.registrationNo,
      this.location,
      this.customerName,
      this.scheduleDate,
      this.kms,
      this.bookingSource,
      this.alternateContactPerson,
      this.alternatePersonContactNo,
      this.salesPerson,
      this.bay,
      this.jobType,
      this.customerConcerns,
      this.remarks});

  Service.fromJson(Map<String, dynamic> json) {
    registrationNo = json['vehicle_registration_no'];
    location = json['location'];
    customerName = json['customer_name'];
    scheduleDate = json['schedule_date'];
    kms = json['kms'];
    bookingSource = json['booking_source'];
    alternateContactPerson = json['alternate_contact_person'];
    alternatePersonContactNo = json['alternate_contact_person_contact_no'];
    salesPerson = json['sales_person'];
    bay = json['bay'];
    jobType = json['job_type'];
    customerConcerns = json['customer_concerns'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_registration_no'] = registrationNo;
    data['location'] = location;
    data['customer_name'] = registrationNo;
    data['schedule_date'] = registrationNo;
    data['kms'] = registrationNo;
    data['booking_source'] = registrationNo;
    data['alternate_contact_person'] = registrationNo;
    data['alternate_contact_person_contact_no'] = registrationNo;
    data['sales_person'] = registrationNo;
    data['bay'] = registrationNo;
    data['job_type'] = registrationNo;
    data['customer_concerns'] = registrationNo;
    data['remarks'] = registrationNo;
    return data;
  }
}
