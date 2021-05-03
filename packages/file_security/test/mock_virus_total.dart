import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_validate/server.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

Future configureServer(Angel app) async {
  var scans = <_VirusScan>[];
  var uuid = new Uuid();

  var requireApiKey = new Validator({
    'apikey*': isNonEmptyString,
  });

  // Create file scan...
  app.post(
      '/file/scan',
      waterfall([
        validate(requireApiKey),
        (RequestContext req) async {
          var file = req.files.first;
          var scan = new _VirusScan(
              uuid.v4(), file.filename.endsWith('.virus') ? 50 : 0);
          scans.add(scan);
          return {'scan_id': scan.id};
        }
      ]));

  var requireResource = requireApiKey.extend({
    'resource*': isNonEmptyString,
  });

  app.post(
      '/url/report',
      waterfall([
        validate(requireResource),
        (RequestContext req) async {
          var scanId = req.body['resource'];
          var scan = scans.firstWhere(
            (s) => s.id == scanId,
            orElse: () => throw new AngelHttpException.notFound(
                message: 'Unknown resource.'),
          );
          return {'positives': scan.positives};
        }
      ]));

  app.use(() => throw new AngelHttpException.notFound());

  app.logger = new Logger('mock_virus_total');
}

class _VirusScan {
  final String id;
  final int positives;
  _VirusScan(this.id, this.positives);
}
