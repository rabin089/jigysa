class ApiUrl {
  // static String baseURL = "https://api-jigyasa.rabindulal.com.np/api/v1";

  //ngrok
  static String baseURL =
      "https://nondivisive-atomic-mui.ngrok-free.dev/api/v1";

  //auth
  static String loginApi = "/auth/login";
  static String signupApi = "/auth/signup";
  static String oAuthLogin = '/auth/verify/google';
  static String oAuthAppleLogin = "/auth/verify/apple";

  ///user-profile
  static String getUserProfile = "/user/me";

  //ideas
  static String getAllIdeas = "/ideas/all";
  static String createIdea = "/ideas/create";
  static String updateIdea({required String id}) => "/ideas/{$id}";
  static String deleteIdea({required String id}) => "/ideas/{$id}";
  static String getMyIdeas = "/ideas/mine";

  ///comments
}
