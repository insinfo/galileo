import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_mustache/galileo_mustache.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

const FileSystem fs = const LocalFileSystem();

configureServer(Galileo app) async {
  // Run the plug-in
  await app.configure(mustache(fs.directory('views')));

  // Render `hello.mustache`
  app.get('/', (req, res) async {
    await res.render('hello', {'name': 'world'});
  });
}
