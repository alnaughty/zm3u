import 'package:m3u_z_parser/src/models/m3u_entry.dart';

mixin Categorizer {
  Map<String, List<M3uEntry>> categorize(
      {required List<M3uEntry> data, required String needle}) {
    return data.fold(<String, List<M3uEntry>>{}, (acc, current) {
      final property = current.attributes[needle] ?? "tvg-id";

      if (!acc.containsKey(property)) {
        acc[property] = [current];
      } else {
        acc[property]!.add(current);
      }
      return acc;
    });
  }
}
