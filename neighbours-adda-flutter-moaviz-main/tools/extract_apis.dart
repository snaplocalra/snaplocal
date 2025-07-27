import 'dart:io';

void main() {
  final directory = Directory('../lib');
  final dioPostPattern = RegExp(r'''dio\.post\(['\"]([^'\"]+)['\"]''');

  final csvFile = File('api_matches.csv');
  final csvSink = csvFile.openWrite();

  directory
      .listSync(recursive: true, followLinks: false)
      .forEach((FileSystemEntity entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final fileContent = entity.readAsStringSync();
      final matches = dioPostPattern.allMatches(fileContent);

      for (final match in matches) {
        final apiEndpoint = match.group(1);
        csvSink.writeln('$apiEndpoint');
      }
    }
  });

  // Close the CSV sink
  csvSink.close();
}
