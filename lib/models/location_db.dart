class Location {
  int id;
  int gpsPollInterval;
  int gpsPostInterval;
  String gpsUrl;
  

  Location({this.id, this.gpsPollInterval, this.gpsPostInterval,this.gpsUrl});


  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        gpsPollInterval: json["gps_poll_interval"],
        gpsPostInterval: json["gps_post_interval"],
        gpsUrl: json["gps_url"]
        );

  Map<String, dynamic> toJson() => {
        "id" : id,
        "gps_poll_interval": gpsPollInterval,
        "gps_post_interval": gpsPostInterval,
        "gps_url":gpsUrl
        };      
}
