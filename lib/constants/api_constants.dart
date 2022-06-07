class ApiBase {
  static const String  baseUrl = "https://sell-order.com/api/" ;
}

class ApiEndPoint {
  static const String authentication = "TokenAuth/Authenticate" ;
  static const String register = "services/app/Account/Register" ;
  static const String getProfileDetails = "services/app/Profile/GetCurrentUserProfileForEdit" ;
  static const String getUserImage = "services/app/Profile/GetProfilePicture" ;
  static const String updateProfile = "services/app/Profile/UpdateCurrentUserProfile" ;
}