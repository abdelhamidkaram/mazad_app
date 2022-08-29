class FAQModel {
  Faq? faq;

  FAQModel({this.faq});

  FAQModel.fromJson(Map<String, dynamic> json) {
    faq = json['faq'] != null ? Faq.fromJson(json['faq']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (faq != null) {
      data['faq'] = faq!.toJson();
    }
    return data;
  }
}

class Faq {
  String? qustion;
  String? answer;
  int? id;

  Faq({this.qustion, this.answer, this.id});

  Faq.fromJson(Map<String, dynamic> json) {
    qustion = json['qustion'];
    answer = json['answer'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qustion'] = qustion;
    data['answer'] = answer;
    data['id'] = id;
    return data;
  }
}