class ProfileEditSuccess {
  UserModel? result;

   ProfileEditSuccess({this.result});

  ProfileEditSuccess.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? UserModel.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ( result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class UserModel {
  String? name;
  String? surname;
  String? userName;
  String? emailAddress;
  String? phoneNumber;
  bool? isPhoneNumberConfirmed;
  String? timezone;
  String? qrCodeSetupImageUrl;
  bool? isGoogleAuthenticatorEnabled;
  int? userId  = 3 ; //TODO: get user id from server

  UserModel(
      {this.name,
        this.surname,
        this.userName,
        this.emailAddress,
        this.phoneNumber,
        this.isPhoneNumberConfirmed,
        this.timezone,
        this.qrCodeSetupImageUrl,
        this.isGoogleAuthenticatorEnabled,
        this.userId
      });


  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    userName = json['userName'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    isPhoneNumberConfirmed = json['isPhoneNumberConfirmed'];
    timezone = json['timezone'];
    qrCodeSetupImageUrl = json['qrCodeSetupImageUrl'];
    isGoogleAuthenticatorEnabled = json['isGoogleAuthenticatorEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['surname'] = surname;
    data['userName'] = userName;
    data['emailAddress'] = emailAddress;
    data['phoneNumber'] = phoneNumber;
    data['isPhoneNumberConfirmed'] = isPhoneNumberConfirmed;
    data['timezone'] = timezone;
    data['qrCodeSetupImageUrl'] = qrCodeSetupImageUrl;
    data['isGoogleAuthenticatorEnabled'] = isGoogleAuthenticatorEnabled;
    return data;
  }
}
