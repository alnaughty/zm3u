import 'package:m3u_z_parser/src/models/entry_info.dart';
export 'package:m3u_z_parser/src/models/entry_info.dart';

class M3uEntry {
  /// Generic constructor with
  ///
  /// [title] of the track/stream
  /// [attributes] custom attributes, can be null
  /// [link] the link to the source of the track/stream
  /// [duration] the duration of the track found after '#EXTINF:'
  /// [type] the m3u type whether it is LIVE, MOVIE, and/or SERIES
  M3uEntry(
      {required this.title,
      required this.attributes,
      required this.link,
      required this.duration,
      required this.type});

  /// Constructor from an [EntryInformation2] that only hold the title
  /// and attributes of a track/stream
  factory M3uEntry.fromEntryInformation(
          {required EntryInfo information,
          required String link,
          int type = 0}) =>
      M3uEntry(
        title: information.title,
        duration: information.duration,
        attributes: information.attributes,
        link: link,
        type: type.toLMS(),
      );

  /// Hold the information about the track.
  /// This is a raw string there are some formats specific to playlists, but
  /// this is the raw string check EX: `#EXTINF:191,Artist Name - Track Title`
  String title;

  /// Attributes parsed from the line of metadata
  /// Ex:
  /// `#EXTINF:-1 tvg-id="identifier" group-title="The Only one",A TV channel`
  Map<String, String?> attributes;

  /// Source of the track/stream url that points to a track/stream
  String link;

  /// number of duration in minutes, -1 if hls
  int duration;

  /// Simple representation of the object on a string.
  @override
  String toString() => '${toJson()}';
  LMSType type;

  /// converting to json format
  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "duration": duration,
        "attributes": attributes,
        "type": type.toInt(),
      };
}

enum LMSType { LIVE, MOVIE, SERIES, NONE }

extension LMSConvert on LMSType {
  int toInt() {
    switch (this) {
      case LMSType.LIVE:
        return 1;
      case LMSType.MOVIE:
        return 2;
      case LMSType.SERIES:
        return 3;
      case LMSType.NONE:
        return 0;
    }
  }
}

extension LMSTo on int {
  LMSType toLMS() {
    switch (this) {
      case 0:
        return LMSType.NONE;
      case 1:
        return LMSType.LIVE;
      case 2:
        return LMSType.MOVIE;
      case 3:
        return LMSType.SERIES;
      default:
        return LMSType.NONE;
    }
  }
}
