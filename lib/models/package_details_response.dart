class PackageDetailsResponse {
  String message;
  String container;
  String order;
  String destination;
  String trackingNum;

  PackageDetailsResponse(
      {this.message,
      this.container,
      this.order,
      this.destination,
      this.trackingNum});

  PackageDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    container = json['container'];
    order = json['order'];
    destination = json['destination'];
    trackingNum = json['trackingNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['container'] = this.container;
    data['order'] = this.order;
    data['destination'] = this.destination;
    data['trackingNum'] = this.trackingNum;
    return data;
  }
}