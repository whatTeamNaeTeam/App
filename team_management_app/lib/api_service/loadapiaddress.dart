import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoadAPIAddress {
  static final apiurl = dotenv.env['API_SERVER'];

  // 로그인 api url
  static String loginapiurl() {
    return "$apiurl/api/auth/github/login";
  }

  // 회원가입 api url
  static String signupapiurl() {
    return "$apiurl/api/auth/github/finish";
  }

  static String manageapiurl() {
    return "$apiurl/api/admin/user/manage";
  }

  static String approveurl(int userid) {
    return "$apiurl/api/user/manage/$userid";
  }

  static String createTeamUrl() {
    return "$apiurl/api/team/create";
  }
}
