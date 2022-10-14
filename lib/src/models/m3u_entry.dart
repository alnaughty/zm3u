import 'package:m3u_z_parser/src/models/entry_info.dart';

class M3uEntry {
  /// Generic constructor with
  ///
  /// [title] of the track/stream
  /// [attributes] custom attributes, can be null
  /// [link] the link to the source of the track/stream
  /// [duration] the duration of the track found after '#EXTINF:'
  M3uEntry(
      {required this.title,
      required this.attributes,
      required this.link,
      required this.duration});

  /// Constructor from an [EntryInformation2] that only hold the title
  /// and attributes of a track/stream
  factory M3uEntry.fromEntryInformation(
          {required EntryInfo information, required String link}) =>
      M3uEntry(
        title: information.title,
        duration: information.duration,
        attributes: information.attributes,
        link: link,
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

  /// converting to json format
  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "duration": duration,
        "attributes": attributes,
      };
}
