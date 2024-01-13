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
  static const searchResult = "/search_result";
}

class AssetsContants {
  static const chatLottie = "assets/lottie/chat.json";
  static const defaultAvatar =
      "https://chat-api.kuriyama.top/Raw/DefaultAvatar/1.jpg";
  static const loading = "assets/images/loading.gif";
}

String formatPlaycount(int? count) {
  if (count == null) {
    return "0";
  }

  if (count < 10000) {
    return count.toString();
  }

  return "${(count / 10000).toStringAsFixed(1)}万";
}

String formatMusicImageUrl(String? url, {int? size, int? width, int? height}) {
  if (url == null) {
    return AssetsContants.defaultAvatar;
  }

  if (size != null) {
    width = size;
    height = size;
  } else if (width != null && height == null) {
    height = width;
  } else if (width == null && height != null) {
    width = height;
  }

  if (width != null && height != null) {
    return "$url?param=${width}y$height";
  }

  if (url.startsWith('http://')) {
    url = url.replaceFirst('http://', 'https://');
  }

  return url;
}

class Global {
  static String cookie = "";
}
