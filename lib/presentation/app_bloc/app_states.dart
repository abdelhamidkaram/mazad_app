abstract class AppStates {}

class InitState extends AppStates {}

class OnBoardingIndexLoading extends AppStates {}
class OnBoardingIndexSuccess extends AppStates {}
class OnBoardingIndexError extends AppStates {}

class InitPrefsState extends AppStates {}

class GetTokenState extends AppStates {}


//get profile details
class GetProfileDetailsLoading extends AppStates{}
class GetProfileDetailsSuccess extends AppStates{}
class GetProfileDetailsError extends AppStates{}



//get check internet connected
class CheckInternetLoading extends AppStates{}
class InternetConnectionSuccess extends AppStates{}
class NoInternetConnection extends AppStates{}



//new install
class NewInstallLoading extends AppStates{}
class NewInstallSuccess extends AppStates{}
class NewInstall extends AppStates{}



// conf
class GetSystemConfLoading extends AppStates{}
class GetSystemConfSuccess extends AppStates{}
class GetSystemConfError extends AppStates{}


// img
class GetImgLoading extends AppStates{}
class GetImgSuccess extends AppStates{}
class GetImgError extends AppStates{}


