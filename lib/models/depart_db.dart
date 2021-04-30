class Depart {
  int id;
  String location;
  int scanTime;
  int isSynced;
  String trackingNo;
  int packageCount;
  

  Depart({this.id, this.location, this.scanTime,this.isSynced,this.trackingNo,this.packageCount});


  factory Depart.fromJson(Map<String, dynamic> json) => Depart(
        id: json["id"],
        location: json["location"],
        scanTime: json["scan_time"],
        isSynced: json["is_synced"],
        trackingNo: json["tracking_number"],
        packageCount: json["package_count"]
        );

  Map<String, dynamic> toJson() => {
        "id" : id,
        "location": location,
        "scan_time": scanTime,
        "is_synced":isSynced,
        "tracking_number":trackingNo,
        "package_count":packageCount
        };      
}
