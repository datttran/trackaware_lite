import 'dart:convert';
import 'dart:ui';

class Tender {
  String orderNo;
  String priority;
  String location;
  int qty;
  String destination;
  

  Tender(
    this.orderNo,
    this.priority,
    this.location,
    this.qty,
    this.destination,
  );

  // Tender(String orderNo,String priority,String location,int qty,String destination){
  //   this.order_no = orderNo;
  //   this.priority = priority;
  //   this.location = location;
  //   this.Qty = qty;
  //   this.Destination = destination;
  // }

  Tender copyWith({
    String orderNo,
    String priority,
    String location,
    int qty,
    String destination,
  }) {
    return Tender(
      this.orderNo,
      this.priority,
      this.location,
      this.qty,
      this.destination,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_no': orderNo,
      'priority': priority,
      'location': location,
      'Qty': qty,
      'Destination': destination,
    };
  }

  // static Tender fromMap(Map<String, dynamic> map) {
  //   if (map == null) return null;
  
  //   return Tender(
  //     order_no: map['order_no'],
  //     priority: map['priority'],
  //     location: map['location'],
  //     Qty: map['Qty']?.toInt(),
  //     Destination: map['Destination'],
  //   );
  // }

  String toJson() => json.encode(toMap());

  // static Tender fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Tender order_no: $orderNo, priority: $priority, location: $location, Qty: $qty, Destination: $destination';
  }

  @override
  bool operator ==(Object o) {
    return o is Tender &&
      o.orderNo == orderNo &&
      o.priority == priority &&
      o.location == location &&
      o.qty == qty &&
      o.destination == destination;
  }

  @override
  int get hashCode {
    return hashList([
      orderNo,
      priority,
      location,
      qty,
      destination,
    ]);
  }
}
