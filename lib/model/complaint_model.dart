
class ComplaintModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<ComplaintResult>? results;
  ComplaintModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });
  factory ComplaintModel.fromJson(Map<String, dynamic> json) => ComplaintModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<ComplaintResult>.from(json["results"]!.map((x) => ComplaintResult.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}
class ComplaintResult {
  int? id;
  String? status;
  String? technician;
  Complaint? complaint;
  String? reason;
  DateTime? updatedOn;
  ComplaintResult({
    this.id,
    this.status,
    this.technician,
    this.complaint,
    this.reason,
    this.updatedOn,
  });
  factory ComplaintResult.fromJson(Map<String, dynamic> json) => ComplaintResult(
    id: json["id"],
    status: json["status"],
    technician: json["technician"],
    complaint: json["complaint"] == null ? null : Complaint.fromJson(json["complaint"]),
    reason: json["reason"],
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "technician": technician,
    "complaint": complaint?.toJson(),
    "reason": reason,
    "updated_on": "${updatedOn!.year.toString().padLeft(4, '0')}-${updatedOn!.month.toString().padLeft(2, '0')}-${updatedOn!.day.toString().padLeft(2, '0')}",
  };
}
class Complaint {
  String? name;
  int? productObj;
  dynamic product;
  String? category;
  String? brand;
  String? complaintId;
  int? complaintIdInternal;
  String? complaint;
  dynamic invoiceNumber;
  String? customerName;
  String? houseName;
  dynamic streetName;
  String? locationName;
  dynamic landmark;
  String? pincode;
  String? contactNumber;
  dynamic alternativeContactNumber;
  Complaint({
    this.name,
    this.productObj,
    this.product,
    this.category,
    this.brand,
    this.complaintId,
    this.complaintIdInternal,
    this.complaint,
    this.invoiceNumber,
    this.customerName,
    this.houseName,
    this.streetName,
    this.locationName,
    this.landmark,
    this.pincode,
    this.contactNumber,
    this.alternativeContactNumber,
  });
  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    name: json["name"],
    productObj: json["product_obj"],
    product: json["product"],
    category: json["category"],
    brand: json["brand"],
    complaintId: json["complaint_id"],
    complaintIdInternal: json["complaint_id_internal"],
    complaint: json["complaint"],
    invoiceNumber: json["invoice_number"],
    customerName: json["customer_name"],
    houseName: json["house_name"],
    streetName: json["street_name"],
    locationName: json["location_name"],
    landmark: json["landmark"],
    pincode: json["pincode"],
    contactNumber: json["contact_number"],
    alternativeContactNumber: json["alternative_contact_number"],
  );
  Map<String, dynamic> toJson() => {
    "name": name,
    "product_obj": productObj,
    "product": product,
    "category": category,
    "brand": brand,
    "complaint_id": complaintId,
    "complaint_id_internal": complaintIdInternal,
    "complaint": complaint,
    "invoice_number": invoiceNumber,
    "customer_name": customerName,
    "house_name": houseName,
    "street_name": streetName,
    "location_name": locationName,
    "landmark": landmark,
    "pincode": pincode,
    "contact_number": contactNumber,
    "alternative_contact_number": alternativeContactNumber,
  };
}