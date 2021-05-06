import 'package:galileo_framework/galileo_framework.dart';

import 'user_agent.dart';

/// Injects a [UserAgent] factory into requests.
///
/// Because it is an injected factory, the user agent will not be
/// parsed until you request it via `req.container.make<UserAgent>()`.
bool parseUserAgent(RequestContext req, ResponseContext res) {
  req.container.registerFactory<UserAgent>((container) {
    var agentString = req.headers.value('user-agent');

    if (agentString?.trim()?.isNotEmpty != true) {
      throw new GalileoHttpException.badRequest(message: 'User-Agent header is required.');
    }

    var userAgent = new UserAgent(agentString);
    container.registerSingleton<UserAgent>(userAgent);
    return userAgent;
  });

  return true;
}
