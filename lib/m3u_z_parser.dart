library m3u_z_parser;

import 'dart:convert';

import 'package:m3u_z_parser/mixin/mixin.dart';
import 'package:m3u_z_parser/src/enum.dart';
import 'package:m3u_z_parser/src/exception.dart';
import 'package:m3u_z_parser/src/file_type.dart';
import 'package:m3u_z_parser/src/models/entry_info.dart';
import 'package:m3u_z_parser/src/models/m3u_entry.dart';
export 'package:m3u_z_parser/extension/extension.dart';

class M3uZParser with Categorizer {
  static Future<List<M3uEntry>> parse(String source) async =>
      M3uZParser()._parse(source);

  /// Internally used after the header is parsed.
  FileTypeHeader? _fileType;

  /// Controller for the current state of the parser
  /// This flag indicates the next type of data that we expect.
  LineParsedType _nextLineExpected = LineParsedType.header;

  /// Current holder of the information about the current Track
  EntryInfo? _currentInfoEntry;
  final List<M3uEntry> _playlist = <M3uEntry>[];
  Future<List<M3uEntry>> _parse(String source) async {
    LineSplitter.split(source).forEach(_parseLine);
    return _playlist;
  }

  void _parseLine(String line) {
    switch (_nextLineExpected) {
      case LineParsedType.header:
        _fileType = FileTypeHeader.fromString(line);
        _nextLineExpected = LineParsedType.info;
        break;
      case LineParsedType.info:
        final parsedEntry = _parseInfoRow(line, _fileType);
        if (parsedEntry == null) {
          break;
        }
        _currentInfoEntry = parsedEntry;
        _nextLineExpected = LineParsedType.source;
        break;
      case LineParsedType.source:
        if (_currentInfoEntry == null) {
          _nextLineExpected = LineParsedType.info;
          _parseLine(line);
          break;
        }
        _playlist.add(M3uEntry.fromEntryInformation(
            information: _currentInfoEntry!, link: line));
        _currentInfoEntry = null;
        _nextLineExpected = LineParsedType.info;
        break;
    }
  }

  EntryInfo? _parseInfoRow(String line, FileTypeHeader? fileType) {
    switch (fileType) {
      case FileTypeHeader.m3u:
        return _regexParse(line);
      case FileTypeHeader.m3uPlus:
        return _regexParse(line);
      default:
        throw InvalidFormatException(InvalidFormatType.other,
            originalValue: line);
    }
  }

  EntryInfo _regexParse(String line) {
    final RegExp firstNumber = RegExp("-?(\\d+)");
    final String? match = firstNumber.allMatches(line).first.group(0);
    final regexExpression = RegExp(r' (.*?)=\"(.*?)"|,(.*)');
    final matches = regexExpression.allMatches(line);
    final attributes = <String, String?>{};
    String? title = '';
    final int duration = match != null ? int.parse(match) : -1;

    for (var match in matches) {
      if (match[1] != null && match[2] != null) {
        attributes[match[1]!] = match[2];
      } else if (match[3] != null) {
        title = match[3];
      } else {
        print('ERROR regexing against -> ${match[0]}');
        throw InvalidFormatException(
          InvalidFormatType.other,
        );
      }
    }
    return EntryInfo(
      title: title!,
      attributes: attributes,
      duration: duration,
    );
  }
}
