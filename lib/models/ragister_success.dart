class RegisterSuccessModel {
  Result? result;
  bool? success;
  bool? unAuthorizedRequest;
  bool? bAbp;

  RegisterSuccessModel(
      {this.result, this.success, this.unAuthorizedRequest, this.bAbp});

  RegisterSuccessModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
    success = json['success'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['success'] = success;
    data['unAuthorizedRequest'] = unAuthorizedRequest;
    data['__abp'] = bAbp;
    return data;
  }
}

class Result {
  bool? canLogin;

  Result({this.canLogin});

  Result.fromJson(Map<String, dynamic> json) {
    canLogin = json['canLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['canLogin'] = canLogin;
    return data;
  }
}