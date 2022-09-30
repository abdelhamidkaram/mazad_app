
class NotificationModel {
  int? tenantId;
  int? userId;
  int? state;
  NotificationMSG? notification;
  String? id;

  NotificationModel(
  {this.tenantId, this.userId, this.state, this.notification, this.id});

  NotificationModel.fromJson(Map<String, dynamic> json) {
  tenantId = json['tenantId'];
  userId = json['userId'];
  state = json['state'];
  notification = json['notification'] != null
  ?  NotificationMSG.fromJson(json['notification'])
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
  data['id'] = id;
  return data;
  }
  }

  class NotificationMSG {
  int? tenantId;
  String? notificationName;
  Data? data;
  Null? entityType;
  Null? entityTypeName;
  Null? entityId;
  int? severity;
  String? creationTime;
  String? id;

  NotificationMSG(
  {this.tenantId,
  this.notificationName,
  this.data,
  this.entityType,
  this.entityTypeName,
  this.entityId,
  this.severity,
  this.creationTime,
  this.id});

  NotificationMSG.fromJson(Map<String, dynamic> json) {
  tenantId = json['tenantId'];
  notificationName = json['notificationName'];
  data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  entityType = json['entityType'];
  entityTypeName = json['entityTypeName'];
  entityId = json['entityId'];
  severity = json['severity'];
  creationTime = json['creationTime'];
  id = json['id'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  <String, dynamic>{};
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
  String? message;
  String? type;
  Properties? properties;

  Data({this.message, this.type, this.properties});

  Data.fromJson(Map<String, dynamic> json) {
  message = json['message'];
  type = json['type'];
  properties = json['properties'] != null
  ?  Properties.fromJson(json['properties'])
      : null;
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  <String, dynamic>{};
  data['message'] = message;
  data['type'] = type;
  if (properties != null) {
  data['properties'] = properties!.toJson();
  }
  return data;
  }
  }

  class Properties {
  String? message;

  Properties({this.message});

  Properties.fromJson(Map<String, dynamic> json) {
  message = json['Message'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  <String, dynamic>{};
  data['Message'] =message;
  return data;
  }
  }