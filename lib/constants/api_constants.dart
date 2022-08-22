class ApiBase {
  static const String  baseUrl = "https://sell-order.com/" ;
}

class ApiEndPoint {
  static const String authentication = "api/TokenAuth/Authenticate" ;
  static const String register = "api/services/app/Account/Register" ;
  static const String getProfileDetails = "api/services/app/Profile/GetCurrentUserProfileForEdit" ;
  static const String getUserImage = "api/services/app/Profile/GetProfilePicture" ;
  static const String updateProfile = "api/services/app/Profile/UpdateCurrentUserProfile" ;
  static const String getAllProducts = "api/services/app/Products/GetAll" ;
  static const String getAllCategories = "api/services/app/Categories/GetAll" ;
  static const String uploadProducts = "api/services/app/Products/CreateOrEdit" ;
  static const String addBid = "api/services/app/ProductAuactions/CreateOrEdit" ;
  static const String myBid = "api/services/app/ProductAuactions/GetAll" ;
  static const String myFavorite = "api/services/app/ProductFavorites/GetAll";
  static const String addToFavorite = "api/services/app/ProductFavorites/CreateOrEdit";
  static const String deleteFavorite = "api/services/app/ProductFavorites/Delete";

}