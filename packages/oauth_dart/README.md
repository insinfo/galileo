An implementation of OAuth 1.0a, as per RFC 5849. 

The client portion is designed for use with the http 
package. The server portion is designed to work with the dart:io
HttpServer class. 

Supports HMAC-SHA1 and RSA-SHA1 signatures. HMAC-SHA1 is well tested, RSA-SHA1
is completely untested and experimental. PAINTEXT signatures are unsupported.

Comes with a test suite. Please report any incompatibility issues.
