// ignore_for_file: prefer_void_to_null, unnecessary_question_mark

class LoginSuccessModel {
  Result? result;
  String? targetUrl;
  bool? success;
  String? error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  LoginSuccessModel(
      {this.result,
        this.targetUrl,
        this.success,
        this.error,
        this.unAuthorizedRequest,
        this.bAbp});

  LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['targetUrl'] = targetUrl;
    data['success'] = success;
    data['error'] = error;
    data['unAuthorizedRequest'] = unAuthorizedRequest;
    data['__abp'] = bAbp;
    return data;
  }
}

class Result {
  String? accessToken;
  String? encryptedAccessToken;
  int? expireInSeconds;
  bool? shouldResetPassword;
  String? passwordResetCode;
  int? userId;
  bool? requiresTwoFactorVerification;
  Null? twoFactorAuthProviders;
  Null? twoFactorRememberClientToken;
  Null? returnUrl;
  String? refreshToken;
  int? refreshTokenExpireInSeconds;

  Result(
      {this.accessToken,
        this.encryptedAccessToken,
        this.expireInSeconds,
        this.shouldResetPassword,
        this.passwordResetCode,
        this.userId,
        this.requiresTwoFactorVerification,
        this.twoFactorAuthProviders,
        this.twoFactorRememberClientToken,
        this.returnUrl,
        this.refreshToken,
        this.refreshTokenExpireInSeconds});

  Result.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    encryptedAccessToken = json['encryptedAccessToken'];
    expireInSeconds = json['expireInSeconds'];
    shouldResetPassword = json['shouldResetPassword'];
    passwordResetCode = json['passwordResetCode'];
    userId = json['userId'];
    requiresTwoFactorVerification = json['requiresTwoFactorVerification'];
    twoFactorAuthProviders = json['twoFactorAuthProviders'];
    twoFactorRememberClientToken = json['twoFactorRememberClientToken'];
    returnUrl = json['returnUrl'];
    refreshToken = json['refreshToken'];
    refreshTokenExpireInSeconds = json['refreshTokenExpireInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['encryptedAccessToken'] = encryptedAccessToken;
    data['expireInSeconds'] = expireInSeconds;
    data['shouldResetPassword'] = shouldResetPassword;
    data['passwordResetCode'] = passwordResetCode;
    data['userId'] = userId;
    data['requiresTwoFactorVerification'] = requiresTwoFactorVerification;
    data['twoFactorAuthProviders'] = twoFactorAuthProviders;
    data['twoFactorRememberClientToken'] = twoFactorRememberClientToken;
    data['returnUrl'] = returnUrl;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpireInSeconds'] = refreshTokenExpireInSeconds;
    return data;
  }
}

