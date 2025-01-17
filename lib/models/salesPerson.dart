class SalesPerson {
  int? empId;
  String? empName;

  SalesPerson({this.empId, this.empName});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_id'] = empId;
    data['emp_name'] = empName;
    return data;
  }
}
