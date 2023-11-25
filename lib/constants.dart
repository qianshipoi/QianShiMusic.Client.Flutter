const appTitle = "QianShiChat";
const accessTokenKey = "token";
const userInfoKey = "current_user";

class ApiContants {
  static const baseUrl = "https://kuriyama.top/music-api/";
}

class RouterContants {
  static const settings = "/settings";
  static const login = "/login";
  static const search = "/search";
  static const playlistDetail = "/playlistDetail";
  static const searchResult = "/search_result";
}

class AssetsContants {
  static const chatLottie = "assets/lottie/chat.json";
  static const defaultAvatar =
      "https://chat-api.kuriyama.top/Raw/DefaultAvatar/1.jpg";
}

String formatMusicImageUrl(String url, {int? size}) {
  return url + (size == null ? "" : "?param=$size");
}

class Global {
  static String cookie = "";
}
