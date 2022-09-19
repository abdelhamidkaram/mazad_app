class SystemConfigrationModel {
  SystemConfigration? systemConfigration;

  SystemConfigrationModel({this.systemConfigration});

  SystemConfigrationModel.fromJson(Map<String, dynamic> json) {
    systemConfigration = json['systemConfigration'] != null
        ? SystemConfigration.fromJson(json['systemConfigration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (systemConfigration != null) {
      data['systemConfigration'] = systemConfigration!.toJson();
    }
    return data;
  }
}

class SystemConfigration {
  String? slideTitle;
  String? slideDescription;
  String? slideBtnText;
  String? slideBtnLink;
  String? link;
  String? keyName;
  int? id;

  SystemConfigration(
      {this.slideTitle,
        this.slideDescription,
        this.slideBtnText,
        this.slideBtnLink,
        this.link,
        this.keyName,
        this.id});

  SystemConfigration.fromJson(Map<String, dynamic> json) {
    slideTitle = json['slideTitle'];
    slideDescription = json['slideDescription'];
    slideBtnText = json['slideBtnText'];
    slideBtnLink = json['slideBtnLink'];
    link = json['link'];
    keyName = json['keyName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slideTitle'] = slideTitle;
    data['slideDescription'] = slideDescription;
    data['slideBtnText'] = slideBtnText;
    data['slideBtnLink'] = slideBtnLink;
    data['link'] = link;
    data['keyName'] = keyName;
    data['id'] = id;
    return data;
  }
}