import 'dart:convert';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/dj_radios.dart';
import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/models/video.dart';

class SearchCollectResponse extends BaseResponse {
  final SearchCollectResult? result;
  SearchCollectResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchCollectResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchCollectResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchCollectResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchCollectResponse.fromJson(String source) =>
      SearchCollectResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResult {
  final List<String> order;
  final SearchCollectResultSong? song;
  final SearchCollectResultPlaylist? playList;
  final SearchCollectResultUser? user;
  final SearchCollectResultArtist? artist;
  final SearchCollectResultAlbum? album;
  SearchCollectResult({
    required this.order,
    required this.song,
    required this.playList,
    required this.user,
    required this.artist,
    required this.album,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order': order,
      'song': song?.toMap(),
      'playList': playList?.toMap(),
      'user': user?.toMap(),
      'artist': artist?.toMap(),
      'album': album?.toMap(),
    };
  }

  factory SearchCollectResult.fromMap(Map<String, dynamic> map) {
    return SearchCollectResult(
      order: (map['order'] as List<dynamic>).map((e) => e as String).toList(),
      song: map['song'] != null
          ? SearchCollectResultSong.fromMap(map['song'] as Map<String, dynamic>)
          : null,
      playList: map['playList'] != null
          ? SearchCollectResultPlaylist.fromMap(
              map['playList'] as Map<String, dynamic>)
          : null,
      user: map['user'] != null
          ? SearchCollectResultUser.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      artist: map['artist'] != null
          ? SearchCollectResultArtist.fromMap(
              map['artist'] as Map<String, dynamic>)
          : null,
      album: map['album'] != null
          ? SearchCollectResultAlbum.fromMap(
              map['album'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResult.fromJson(String source) =>
      SearchCollectResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResultSong {
  final String? moreText;
  final bool more;
  final List<int> resourceIds;
  final List<Track> songs;
  SearchCollectResultSong({
    required this.moreText,
    required this.more,
    required this.resourceIds,
    required this.songs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moreText': moreText,
      'more': more,
      'resourceIds': resourceIds,
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchCollectResultSong.fromMap(Map<String, dynamic> map) {
    return SearchCollectResultSong(
      moreText: map['moreText'] != null ? map['moreText'] as String : null,
      more: map['more'] as bool,
      resourceIds:
          (map['resourceIds'] as List<dynamic>).map((e) => e as int).toList(),
      songs: (map['songs'] as List<dynamic>)
          .map<Track>((x) => Track.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResultSong.fromJson(String source) =>
      SearchCollectResultSong.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResultPlaylist {
  final String moreText;
  final bool more;
  final List<int> resourceIds;
  final List<Playlist> playLists;
  SearchCollectResultPlaylist({
    required this.moreText,
    required this.more,
    required this.resourceIds,
    required this.playLists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moreText': moreText,
      'more': more,
      'resourceIds': resourceIds,
      'playLists': playLists.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchCollectResultPlaylist.fromMap(Map<String, dynamic> map) {
    return SearchCollectResultPlaylist(
      moreText: map['moreText'] as String,
      more: map['more'] as bool,
      resourceIds:
          (map['resourceIds'] as List<dynamic>).map((e) => e as int).toList(),
      playLists: List<Playlist>.from(
        (map['playLists'] as List<dynamic>).map<Playlist>(
          (x) => Playlist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResultPlaylist.fromJson(String source) =>
      SearchCollectResultPlaylist.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResultUser {
  final String moreText;
  final bool more;
  final List<int> resourceIds;
  final List<UserProfile> users;
  SearchCollectResultUser({
    required this.moreText,
    required this.more,
    required this.resourceIds,
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moreText': moreText,
      'more': more,
      'resourceIds': resourceIds,
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchCollectResultUser.fromMap(Map<String, dynamic> map) {
    return SearchCollectResultUser(
      moreText: map['moreText'] as String,
      more: map['more'] as bool,
      resourceIds:
          (map['resourceIds'] as List<dynamic>).map((e) => e as int).toList(),
      users: List<UserProfile>.from(
        (map['users'] as List<dynamic>).map<UserProfile>(
          (x) => UserProfile.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResultUser.fromJson(String source) =>
      SearchCollectResultUser.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResultArtist {
  final String? moreText;
  final bool more;
  final List<int> resourceIds;
  final List<Artist> artists;
  SearchCollectResultArtist({
    this.moreText,
    required this.more,
    required this.resourceIds,
    required this.artists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moreText': moreText,
      'more': more,
      'resourceIds': resourceIds,
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchCollectResultArtist.fromMap(Map<String, dynamic> map) {
    return SearchCollectResultArtist(
      moreText: map['moreText'] != null ? map['moreText'] as String : null,
      more: map['more'] as bool,
      resourceIds:
          (map['resourceIds'] as List<dynamic>).map((e) => e as int).toList(),
      artists: List<Artist>.from(
        (map['artists'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResultArtist.fromJson(String source) =>
      SearchCollectResultArtist.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchCollectResultAlbum {
  final String moreText;
  final bool more;
  final List<int> resourceIds;
  final List<Artist> albums;
  SearchCollectResultAlbum({
    required this.moreText,
    required this.more,
    required this.resourceIds,
    required this.albums,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'moreText': moreText,
      'more': more,
      'resourceIds': resourceIds,
      'albums': albums.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchCollectResultAlbum.fromMap(Map<String, dynamic> map) {
    return SearchCollectResultAlbum(
      moreText: map['moreText'] as String,
      more: map['more'] as bool,
      resourceIds:
          (map['resourceIds'] as List<dynamic>).map((e) => e as int).toList(),
      albums: List<Artist>.from(
        (map['albums'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchCollectResultAlbum.fromJson(String source) =>
      SearchCollectResultAlbum.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchSongResponse extends BaseResponse {
  final SearchSongResult? result;
  SearchSongResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchSongResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchSongResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchSongResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchSongResponse.fromJson(String source) =>
      SearchSongResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchSongResult {
  final int songCount;
  final bool hasMore;
  final List<Track> songs;
  SearchSongResult({
    required this.songCount,
    required this.hasMore,
    required this.songs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'songCount': songCount,
      'hasMore': hasMore,
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchSongResult.fromMap(Map<String, dynamic> map) {
    return SearchSongResult(
      songCount: map['songCount'] as int,
      hasMore: map['hasMore'] as bool,
      songs: List<Track>.from(
        (map['songs'] as List<dynamic>).map<Track>(
          (x) => Track.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchSongResult.fromJson(String source) =>
      SearchSongResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchArtistResponse extends BaseResponse {
  final SearchArtistResult? result;
  SearchArtistResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchArtistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchArtistResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchArtistResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchArtistResponse.fromJson(String source) =>
      SearchArtistResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SearchArtistResponse(result: $result)';
}

class SearchArtistResult {
  final bool hasMore;
  final int artistCount;
  final List<Artist> artists;
  SearchArtistResult({
    required this.hasMore,
    required this.artistCount,
    required this.artists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasMore': hasMore,
      'artistCount': artistCount,
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchArtistResult.fromMap(Map<String, dynamic> map) {
    return SearchArtistResult(
      hasMore: map['hasMore'] as bool,
      artistCount: map['artistCount'] as int,
      artists: List<Artist>.from(
        (map['artists'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchArtistResult.fromJson(String source) =>
      SearchArtistResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchArtistResult(hasMore: $hasMore, artistCount: $artistCount, artists: $artists)';
}

class SearchAlbumResponse extends BaseResponse {
  final SearchAlbumResult? result;
  SearchAlbumResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchAlbumResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchAlbumResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchAlbumResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchAlbumResponse.fromJson(String source) =>
      SearchAlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchAlbumResult {
  final int albumCount;
  final List<Album> albums;
  SearchAlbumResult({
    required this.albumCount,
    required this.albums,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'albumCount': albumCount,
      'albums': albums.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchAlbumResult.fromMap(Map<String, dynamic> map) {
    return SearchAlbumResult(
      albumCount: map['albumCount'] as int,
      albums: List<Album>.from(
        (map['albums'] as List<dynamic>).map<Album>(
          (x) => Album.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAlbumResult.fromJson(String source) =>
      SearchAlbumResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchPlaylistResponse extends BaseResponse {
  final SearchPlaylistResult? result;
  SearchPlaylistResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchPlaylistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchPlaylistResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchPlaylistResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchPlaylistResponse.fromJson(String source) =>
      SearchPlaylistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchPlaylistResult {
  final bool hasMore;
  final int playlistCount;
  final List<Playlist> playlists;
  SearchPlaylistResult({
    required this.hasMore,
    required this.playlistCount,
    required this.playlists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasMore': hasMore,
      'playlistCount': playlistCount,
      'playlists': playlists.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchPlaylistResult.fromMap(Map<String, dynamic> map) {
    return SearchPlaylistResult(
      hasMore: map['hasMore'] as bool,
      playlistCount: map['playlistCount'] as int,
      playlists: List<Playlist>.from(
        (map['playlists'] as List<dynamic>).map<Playlist>(
          (x) => Playlist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchPlaylistResult.fromJson(String source) =>
      SearchPlaylistResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchDjRadiosResponse extends BaseResponse {
  final SearchDjRadiosResult? result;
  SearchDjRadiosResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchDjRadiosResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchDjRadiosResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchDjRadiosResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchDjRadiosResponse.fromJson(String source) =>
      SearchDjRadiosResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchDjRadiosResult {
  final bool hasMore;
  final int djRadiosCount;
  final List<DjRadios> djRadios;
  SearchDjRadiosResult({
    required this.hasMore,
    required this.djRadiosCount,
    required this.djRadios,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasMore': hasMore,
      'djRadiosCount': djRadiosCount,
      'djRadios': djRadios.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchDjRadiosResult.fromMap(Map<String, dynamic> map) {
    return SearchDjRadiosResult(
      hasMore: map['hasMore'] as bool,
      djRadiosCount: map['djRadiosCount'] as int,
      djRadios: List<DjRadios>.from(
        (map['djRadios'] as List<dynamic>).map<DjRadios>(
          (x) => DjRadios.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchDjRadiosResult.fromJson(String source) =>
      SearchDjRadiosResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchVideoResponse extends BaseResponse {
  final SearchVideoResult? result;
  SearchVideoResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchVideoResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchVideoResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchVideoResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchVideoResponse.fromJson(String source) =>
      SearchVideoResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchVideoResult {
  final bool hasMore;
  final int videoCount;
  final List<Video> videos;
  SearchVideoResult({
    required this.hasMore,
    required this.videoCount,
    required this.videos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasMore': hasMore,
      'videoCount': videoCount,
      'videos': videos.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchVideoResult.fromMap(Map<String, dynamic> map) {
    return SearchVideoResult(
      hasMore: map['hasMore'] as bool,
      videoCount: map['videoCount'] as int,
      videos: List<Video>.from(
        (map['videos'] as List<dynamic>).map<Video>(
          (x) => Video.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchVideoResult.fromJson(String source) =>
      SearchVideoResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchMvResponse extends BaseResponse {
  final SearchMvResult? result;
  SearchMvResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchMvResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchMvResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchMvResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchMvResponse.fromJson(String source) =>
      SearchMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchMvResult {
  final int mvCount;
  final List<Mv> mvs;
  SearchMvResult({
    required this.mvCount,
    required this.mvs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mvCount': mvCount,
      'mvs': mvs.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchMvResult.fromMap(Map<String, dynamic> map) {
    return SearchMvResult(
      mvCount: map['mvCount'] as int,
      mvs: List<Mv>.from(
        (map['mvs'] as List<dynamic>).map<Mv>(
          (x) => Mv.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchMvResult.fromJson(String source) =>
      SearchMvResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchUserProfileResponse extends BaseResponse {
  final SearchUserProfileResult? result;
  SearchUserProfileResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchUserProfileResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchUserProfileResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchUserProfileResult.fromMap(
              map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchUserProfileResponse.fromJson(String source) =>
      SearchUserProfileResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchUserProfileResult {
  final bool hasMore;
  final int userprofileCount;
  final List<UserProfile> userprofiles;
  SearchUserProfileResult({
    required this.hasMore,
    required this.userprofileCount,
    required this.userprofiles,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hasMore': hasMore,
      'userprofileCount': userprofileCount,
      'userprofiles': userprofiles.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchUserProfileResult.fromMap(Map<String, dynamic> map) {
    return SearchUserProfileResult(
      hasMore: map['hasMore'] as bool,
      userprofileCount: map['userprofileCount'] as int,
      userprofiles: List<UserProfile>.from(
        (map['userprofiles'] as List<dynamic>).map<UserProfile>(
          (x) => UserProfile.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchUserProfileResult.fromJson(String source) =>
      SearchUserProfileResult.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
