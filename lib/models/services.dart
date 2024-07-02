final class Service {
  int? sNo;
  String? registrationNo;
  String? jobCardNo;
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
  String? status;

  Service(
      {this.sNo,
      this.registrationNo,
      this.jobCardNo,
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
      this.status,
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
    jobCardNo = json['job_card_no'];
    customerConcerns = json['customer_concerns'];
    status = json['status'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_registration_no'] = registrationNo;
    data['location'] = location;
    data['customer_name'] = customerName;
    data['schedule_date'] = scheduleDate;
    data['kms'] = kms;
    data['booking_source'] = bookingSource;
    data['alternate_contact_person'] = alternateContactPerson;
    data['alternate_person_contact_no'] = alternatePersonContactNo;
    data['sales_person'] = salesPerson;
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
      String? scheduleDate,
      int? kms,
      String? bookingSource,
      String? alternateContactPerson,
      int? alternatePersonContactNo,
      String? salesPerson,
      String? bay,
      String? jobType,
      String? jobCardNo,
      String? customerConcerns,
      String? remarks}) {
    return Service(
        registrationNo: registrationNo ?? this.registrationNo,
        location: location ?? this.location,
        customerName: customerName ?? this.customerName,
        scheduleDate: scheduleDate ?? this.scheduleDate,
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
        customerConcerns: customerConcerns ?? this.customerConcerns,
        remarks: remarks ?? this.remarks);
  }
}
