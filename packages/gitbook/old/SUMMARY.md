* [Example Projects](https://github.com/galileo-dart/examples-v2)
* [Awesome Galileo](https://github.com/galileo-dart/awesome-galileo)

* Migration from Galileo 1.1.x
  * [Rationale - Why a new Version?](migration/rationale.md)
  * [Framework Chgalileoog](https://github.com/galileo-dart/framework/blob/master/CHANGELOG.md)
  * [2.0.0 Migration Guide](migration/migration-guide.md)

* Social
  * [Galileo on Gitter](https://gitter.im/galileo_dart/discussion)
  * [Galileo on YouTube](https://www.youtube.com/watch?v=52hazf35b0M&list=PLl3P3tmiT-fqGCB2vSPq8HhpugEDNWUo6)
  * [Galileo Blog Entries](https://thosakwe.com/tag/galileo)

* The Basics
  * [Installation & Setup](the-basics/installation.md)
    * [Without the Boilerplate](the-basics/without-the-boilerplate.md)
  * [Requests & Responses](the-basics/requests-and-responses.md)
  * [Dependency Injection](the-basics/dependency-injection.md)
  * [Basic Routing](the-basics/basic-routing.md)
  * [Request Lifecycle](the-basics/request-lifecycle.md)
  * [Middleware](the-basics/middleware.md)
  * [Controllers](the-basics/controllers.md)
  * [Handling File Uploads](the-basics/file-uploads.md)
  * [Using Plug-ins](the-basics/using-plug-ins.md)
  * [Rendering Views](the-basics/rendering-views.md)
  * [REST Client](https://github.com/galileo-dart/client)
  * [Testing](the-basics/testing.md)
  * [Error Handling](the-basics/error-handling.md)
  * [Pattern Matching and `Parameter`](the-basics/pattern-matching.md)
  * [Command Line](the-basics/cli.md)

* Flutter
  * [Writing a Chat App](https://dart.academy/building-a-real-time-chat-app-with-galileo-and-flutter/)
  * [Flutter helper widgets](https://github.com/galileo-dart/flutter)

* Services
  * [Service Basics](services/service-basics.md)
  * [TypedService](services/typedservice.md)
  * [In-Memory](services/in-memory.md)
  * [Custom Services](services/custom-services.md)
  * [Hooks](services/hooks.md)
    * [Bundled Hooks](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework.hooks/galileo_framework.hooks-library.html)
  * [Database-Agnostic Relations](https://github.com/galileo-dart/relations)
  * Database Adapters
    * [MongoDB](https://github.com/galileo-dart/mongo)
    * [RethinkDB](https://github.com/galileo-dart/rethink)
    * [JSON File-based](https://github.com/galileo-dart/file_service)

* Plug-ins
  * [Authentication](https://github.com/galileo-dart/auth)
    * [Local](https://github.com/galileo-dart/auth/wiki/Local-Auth)
    * [Google SSO](https://github.com/galileo-dart/auth_google)
    * [Twitter SSO](https://github.com/galileo-dart/auth_twitter)
    * [Instagram SSO](https://github.com/galileo-dart/auth_instagram)
    * [OAuth2 \(generic\)](https://github.com/galileo-dart/auth_oauth2)
    * [OAuth2 server implementation](https://github.com/galileo-dart/oauth2)
  * [Configuration](https://github.com/galileo-dart/configuration)
  * [Diagnostics & Logging](https://github.com/galileo-dart/diagnostics)
  * [Reverse Proxy](https://github.com/galileo-dart/proxy)
  * [Service Seeder](https://github.com/galileo-dart/seeder)
  * [Static Files](https://github.com/galileo-dart/static)
  * [Validation](https://github.com/galileo-dart/validate)
  * [Websockets](https://github.com/galileo-dart/websocket)
    * [WebSocket synchronization via `pub_sub`](https://github.com/galileo-dart/sync)
  * [Server-sent Events](https://github.com/galileo-dart/eventsource)
  * [Toggle-able Services](https://github.com/galileo-dart/toggle)

* Middleware/Finalizers
  * [CORS](https://github.com/galileo-dart/cors)
  * [Response Compression](https://github.com/galileo-dart/compress)
  * [Security](https://github.com/galileo-dart/security)
  * [File Upload Security](https://github.com/galileo-dart/file_security)
  * [`shelf` Integration](https://github.com/galileo-dart/shelf)
  * [User Agents](https://github.com/galileo-dart/user_agent)
  * [Pagination](https://github.com/galileo-dart/paginate)
  * [`Range`, `If-Range`, `Accept-Ranges` support](https://github.com/galileo-dart/range)

* PostgreSQL ORM
  * [Model Serialization](https://github.com/galileo-dart/serialize)
  * [Query Builder + ORM](https://github.com/galileo-dart/orm)
  * [Migrations](https://github.com/galileo-dart/migration)

* Deployment
  * [Running in Isolates](deployment/running-in-isolates.md)
  * [Configuring SSL](deployment/configuring-ssl.md)
  * [HTTP/2 Support](https://github.com/galileo-dart/http2)
  * [Ubuntu and `nginx`](deployment/ubuntu-and-nginx.md)
  * [AppEngine](deployment/deployment-to-appengine.md)
  * [Production Mode](deployment/production-mode.md)

* Front-end
  * [Mustache Templates](https://github.com/galileo-dart/mustache)
  * [Jael template engine](front-end/jael/README.md)
    * [Github](https://github.com/galileo-dart/jael)
    * [Basics](front-end/jael/Basics.md)
    * [Custom Elements](front-end/jael/Custom-Elements.md)
    * [Strict Resolution](front-end/jael/Strict-Resolution.md)
    * [Directive: `declare`](front-end/jael/Directive:-declare.md)
    * [Directive: `for-each`](front-end/jael/Directive:-for-each.md)
    * [Directive: `extend`](front-end/jael/Directive:-extend.md)
    * [Directive: `if`](front-end/jael/Directive:-if.md)
    * [Directive: `include`](front-end/jael/Directive:-include.md)
    * [Directive: `switch`](front-end/jael/Directive:-switch.md)
  * [`compiled_mustache`-based engine](https://github.com/thislooksfun/galileo_compiled_mustache)
  * [`html_builder`-based engine](https://github.com/galileo-dart/html)
  * [Markdown template engine](https://github.com/galileo-dart/markdown)
  * [Using Galileo with Angular](https://dart.academy/using-galileo-with-angular2/)

* Advanced
  * [API Documentation](http://www.dartdocs.org/documentation/galileo_framework/latest)
  * [Contribute to Galileo](https://github.com/galileo-dart/galileo)
  * [Production Utilities](https://github.com/galileo-dart/production)
  * [Standalone Router](https://github.com/galileo-dart/route)
  * [Writing a Plugin](advanced/writing-a-plugin.md)
  * [Task Engine](https://github.com/galileo-dart/task)
  * [Hot Reloading](https://github.com/galileo-dart/hot)
  * [Real-time polling](https://github.com/galileo-dart/poll)
