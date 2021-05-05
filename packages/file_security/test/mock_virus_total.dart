import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_validate/server.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

Future configureServer(Galileo app) async {
  var scans = <_VirusScan>[];
  var uuid = new Uuid();

  var requireApiKey = new Validator({
    'apikey*': isNonEmptyString,
  });

  // Create file scan...
  app.chain([validate(requireApiKey)]).post('/file/scan', (RequestContext req, ResponseContext resp) async {
    var file = req.uploadedFiles.first;
    var scan = new _VirusScan(uuid.v4(), file.filename.endsWith('.virus') ? 50 : 0);
    scans.add(scan);
    return {'scan_id': scan.id};
  });

  var requireResource = requireApiKey.extend({
    'resource*': isNonEmptyString,
  });

  app.chain([validate(requireResource)]).post('/url/report/:id', (RequestContext req, ResponseContext resp) async {
    var scanId = req.params['id']; //req.body['resource'];
    var scan = scans.firstWhere(
      (s) => s.id == scanId,
      orElse: () => throw new GalileoHttpException.notFound(message: 'Unknown resource.'),
    );
    return {'positives': scan.positives};
  });

  // app.use(() => throw new GalileoHttpException.notFound());

  app.logger = new Logger('mock_virus_total');
}

class _VirusScan {
  final String id;
  final int positives;
  _VirusScan(this.id, this.positives);
}
