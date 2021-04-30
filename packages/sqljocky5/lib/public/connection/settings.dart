import 'package:galileo_sqljocky5/internal/auth/character_set.dart';

export 'package:galileo_sqljocky5/internal/auth/character_set.dart' show CharacterSet;

/// [ConnectionSettings] contains information to connect to MySQL database.
///
///     var s = ConnectionSettings(
///       user: "root",
///       password: "dart_jaguar",
///       host: "localhost",
///       port: 3306,
///       db: "example",
///       useSSL: true,
///     );
///
///     // Establish connection
///     final conn = await MySqlConnection.connect(s);
class ConnectionSettings {
  /// Host of the MySQL server to connect to.
  String? host;

  /// Port of the MySQL server to connect to.
  int? port;

  /// User of the MySQL server to connect to.
  String? user;

  /// Password of the MySQL server to connect to.
  String? password;

  /// Database name to connect to.
  String? db;

  /// Should compression be enabled for communication with the MySQL server?
  bool? useCompression;

  /// Should communication with MySQL be secure?
  bool? useSSL;

  /// Sets the maximum packet size of each communication with MySQL server.
  int? maxPacketSize;

  /// Sets charset for communication with MySQL server.
  int? characterSet;

  /// The timeout for connecting to the database and for all database operations.
  Duration timeout = Duration(seconds: 30);

  ConnectionSettings(
      {this.host = 'localhost',
      this.port = 3306,
      this.user,
      this.password,
      this.db,
      this.useCompression = false,
      this.useSSL = false,
      this.maxPacketSize = 16 * 1024 * 1024,
      this.timeout = const Duration(seconds: 30),
      this.characterSet = CharacterSet.UTF8MB4});

  ConnectionSettings.copy(ConnectionSettings o) {
    this.host = o.host;
    this.port = o.port;
    this.user = o.user;
    this.password = o.password;
    this.db = o.db;
    this.useCompression = o.useCompression;
    this.useSSL = o.useSSL;
    this.maxPacketSize = o.maxPacketSize;
    this.timeout = o.timeout;
    this.characterSet = o.characterSet;
  }
}
