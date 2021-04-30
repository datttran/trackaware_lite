class Arrive {
  int id;
  String location;
  int scanTime;
  int isSynced;
  

  Arrive({this.id, this.location, this.scanTime,this.isSynced});


  factory Arrive.fromJson(Map<String, dynamic> json) => Arrive(
        id: json["id"],
        location: json["location"],
        scanTime: json["scan_time"],
        isSynced: json["is_synced"]
        );

  Map<String, dynamic> toJson() => {
        "id" : id,
        "location": location,
        "scan_time": scanTime,
        "is_synced":isSynced
        };      
}
