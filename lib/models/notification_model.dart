class NotificationModel {
  int? tenantId;
  int? userId;
  int? state;
  Notification? notification;
  String? id;

  NotificationModel(
      {this.tenantId, this.userId, this.state, this.notification, this.id});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    userId = json['userId'];
    state = json['state'];
    notification = json['notification'] != null
        ? Notification.fromJson(json['notification'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tenantId'] = tenantId;
    data['userId'] = userId;
    data['state'] = state;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    data['id'] =id;
    return data;
  }
}

class Notification {
  int? tenantId;
  String? notificationName;
  Data? data;
  String? entityType;
  String? entityTypeName;
  int? entityId;
  int? severity;
  String? creationTime;
  String? id;

  Notification(
      {this.tenantId,
        this.notificationName,
        this.data,
        this.entityType,
        this.entityTypeName,
        this.entityId,
        this.severity,
        this.creationTime,
        this.id});

  Notification.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    notificationName = json['notificationName'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    entityType = json['entityType'];
    entityTypeName = json['entityTypeName'];
    entityId = json['entityId'];
    severity = json['severity'];
    creationTime = json['creationTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tenantId'] = tenantId;
    data['notificationName'] = notificationName;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['entityType'] = entityType;
    data['entityTypeName'] = entityTypeName;
    data['entityId'] = entityId;
    data['severity'] = severity;
    data['creationTime'] = creationTime;
    data['id'] = id;
    return data;
  }
}

class Data {
  Message? message;
  String? type;
  Properties? properties;

  Data({this.message, this.type, this.properties});

  Data.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Message {
  String? sourceName;
  String? name;

  Message({this.sourceName, this.name});

  Message.fromJson(Map<String, dynamic> json) {
    sourceName = json['sourceName'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceName'] = sourceName;
    data['name'] = name;
    return data;
  }
}

class Properties {
  Message? message;
  String? binaryObjectId;

  Properties({this.message, this.binaryObjectId});

  Properties.fromJson(Map<String, dynamic> json) {
    message =
    json['Message'] != null ? Message.fromJson(json['Message']) : null;
    binaryObjectId = json['binaryObjectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['Message'] = message!.toJson();
    }
    data['binaryObjectId'] = binaryObjectId;
    return data;
  }
}