class SalesPerson {
  int? empId;
  String? empName;

  SalesPerson({this.empId, this.empName});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    return data;
  }
}
