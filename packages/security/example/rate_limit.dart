import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_security/galileo_security.dart';
import 'package:logging/logging.dart';
import 'package:galileo_pretty_logging/galileo_pretty_logging.dart';

void main() async {
  // Logging boilerplate.
  Logger.root.onRecord.listen(prettyLog);

  // Create an app, and HTTP driver.
  var app = Galileo(logger: Logger('rate_limit')), http = GalileoHttp(app);

  // Create a simple in-memory rate limiter that limits users to 5
  // queries per 30 seconds.
  //
  // In this case, we rate limit users by IP address.
  var rateLimiter = InMemoryRateLimiter(5, Duration(seconds: 30), (req, res) => req.ip);

  // `RateLimiter.handleRequest` is a middleware, and can be used anywhere
  // a middleware can be used. In this case, we apply the rate limiter to
  // *all* incoming requests.
  app.fallback(rateLimiter.handleRequest);

  // Basic routes.
  app
    ..get('/', (req, res) => 'Hello!')
    ..fallback((req, res) => throw GalileoHttpException.notFound());

  // Start the server.
  await http.startServer('127.0.0.1', 3000);
  print('Rate limiting example listening at ${http.uri}');
}
