import 'dart:io';

// Production environment flag
const bool isProduction = false; // Set to true for production, false for development

// API server URL
const String productionServerHostName = 'https://snaplocalapp.com';
const String devServerHostName = 'https://dev.snaplocalapp.com';
//const String devServerHostName = 'https://preprod.snaplocalapp.com';

//host name
const String hostName = isProduction ? productionServerHostName : devServerHostName;

//base url
const String baseUrl = '$hostName/api/';

//DeepLink URL
const String deepLinkURL = "https://share.snaplocalapp.com";

// API username and password
const String apiusername = 'admin';
const String apipassword = '1234';

// Google API Key
final String googleAPIKey = Platform.isIOS
    ? "AIzaSyAT0QhrAAP8tAXzw9a-Wgw-Imm_JzwT460"
    : "AIzaSyB6nRN4Kk2kRqCcOa8lboUPfX0l0scnoeo";

//Google translate API key
const String googleTranslateAPIKey = "AIzaSyDyaXxEzExvYDCNAexZFkcgMnS1LsgnsdE";

//Google generate model API key
const String googleGenerateModelAPIKey = "AIzaSyBt_z1O4cXVdpeuXhZwHlt7mA3Y7CeAyW8";
