class EndPoints {
  static const String baseUrl = "https://restcountries.com/v3.1/";
  static const String countriesUrl =
      "independent?status=true&fields=name,population,flags,flag,area,region,subregion,timezones";

  // Example endpoints - keeping original for reference
  static const String jsonPlaceholderBaseUrl =
      "https://jsonplaceholder.typicode.com/";
  static const String template = "template/";
  static const String user = "users/";
  static const String post = "posts/";
}

class ApiKey {
  // Country API response keys
  static String name = "name";
  static String common = "common";
  static String population = "population";
  static String flag = "flag";
  static String area = "area";
  static String region = "region";
  static String subregion = "subregion";
  static String timezones = "timezones";

  // JSON Placeholder keys - keeping original for reference
  static String id = "id";
  static String username = "username";
  static String email = "email";
  static String address = "address";
  static String street = "street";
  static String suite = "suite";
  static String city = "city";
  static String zipcode = "zipcode";
  static String geo = "geo";
  static String lat = "lat";
  static String lng = "lng";
  static String phone = "phone";
  static String website = "website";
  static String company = "company";
  static String catchPhrase = "catchPhrase";
  static String bs = "bs";
}
