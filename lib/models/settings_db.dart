class DisciplineConfigResponse {
  int id;
  String keyName;
  String displayName;
  int isVisible;

  DisciplineConfigResponse(
      {this.id, this.keyName, this.displayName, this.isVisible});

  DisciplineConfigResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyName = json['key_name'];
    displayName = json['display_name'];
    isVisible = json['is_visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key_name'] = this.keyName;
    data['display_name'] = this.displayName;
    data['is_visible'] = this.isVisible;
    return data;
  }
}

class SettingsResponse {
  int useToolNumber;
  int driverMode;
  int pickUpOnTender;
  String userName;

  SettingsResponse({this.useToolNumber, this.driverMode, this.userName});

  SettingsResponse.fromJson(Map<String, dynamic> json) {
    useToolNumber = json['use_tool_number'];
    pickUpOnTender = json['pick_on_tender'];
    driverMode = json['driver_mode'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['use_tool_number'] = this.useToolNumber;
    data['pick_on_tender'] = this.pickUpOnTender;
    data['driver_mode'] = this.driverMode;
    data['user_name'] = this.userName;
    return data;
  }
}

class Tabs {
  TabNames tabNames;
  SubDisciplineNames subDisciplineNames;

  Tabs({this.tabNames, this.subDisciplineNames});

  Tabs.fromJson(Map<String, dynamic> json) {
    tabNames = json['tab_names'] != null
        ? new TabNames.fromJson(json['tab_names'])
        : null;
    subDisciplineNames = json['sub_discipline_names'] != null
        ? new SubDisciplineNames.fromJson(json['sub_discipline_names'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tabNames != null) {
      data['tab_names'] = this.tabNames.toJson();
    }
    if (this.subDisciplineNames != null) {
      data['sub_discipline_names'] = this.subDisciplineNames.toJson();
    }
    return data;
  }
}

class TabNames {
  String tender;
  String pickup;
  String delivery;

  TabNames({this.tender, this.pickup, this.delivery});

  TabNames.fromJson(Map<String, dynamic> json) {
    tender = json['tender'];
    pickup = json['pickup'];
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tender'] = this.tender;
    data['pickup'] = this.pickup;
    data['delivery'] = this.delivery;
    return data;
  }
}

class SubDisciplineNames {
  Tender tender;
  Pickup pickup;
  Delivery delivery;

  SubDisciplineNames({this.tender, this.pickup, this.delivery});

  SubDisciplineNames.fromJson(Map<String, dynamic> json) {
    tender =
        json['tender'] != null ? new Tender.fromJson(json['tender']) : null;
    pickup =
        json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tender != null) {
      data['tender'] = this.tender.toJson();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery.toJson();
    }
    return data;
  }
}

class Tender {
  String tenderExternal;
  String tenderProductionPart;

  Tender({this.tenderExternal, this.tenderProductionPart});

  Tender.fromJson(Map<String, dynamic> json) {
    tenderExternal = json['tender_external'];
    tenderProductionPart = json['tender_production_part'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tender_external'] = this.tenderExternal;
    data['tender_production_part'] = this.tenderProductionPart;
    return data;
  }
}

class Pickup {
  String pickupExternal;
  String pickupProductinPart;

  Pickup({this.pickupExternal, this.pickupProductinPart});

  Pickup.fromJson(Map<String, dynamic> json) {
    pickupExternal = json['pickup_external'];
    pickupProductinPart = json['pickup_productin_part'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pickup_external'] = this.pickupExternal;
    data['pickup_productin_part'] = this.pickupProductinPart;
    return data;
  }
}

class Delivery {
  String depart;
  String arrive;

  Delivery({this.depart, this.arrive});

  Delivery.fromJson(Map<String, dynamic> json) {
    depart = json['depart'];
    arrive = json['arrive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['depart'] = this.depart;
    data['arrive'] = this.arrive;
    return data;
  }
}
