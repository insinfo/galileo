* [Example Projects](https://github.com/angel-dart/examples-v2)
* [Awesome Angel](https://github.com/angel-dart/awesome-angel)

* Migration from Angel 1.1.x
  * [Rationale - Why a new Version?](migration/rationale.md)
  * [Framework Changelog](https://github.com/angel-dart/framework/blob/master/CHANGELOG.md)
  * [2.0.0 Migration Guide](migration/migration-guide.md)

* Social
  * [Angel on Gitter](https://gitter.im/angel_dart/discussion)
  * [Angel on YouTube](https://www.youtube.com/watch?v=52hazf35b0M&list=PLl3P3tmiT-fqGCB2vSPq8HhpugEDNWUo6)
  * [Angel Blog Entries](https://thosakwe.com/tag/angel)

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
  * [REST Client](https://github.com/angel-dart/client)
  * [Testing](the-basics/testing.md)
  * [Error Handling](the-basics/error-handling.md)
  * [Pattern Matching and `Parameter`](the-basics/pattern-matching.md)
  * [Command Line](the-basics/cli.md)

* Flutter
  * [Writing a Chat App](https://dart.academy/building-a-real-time-chat-app-with-angel-and-flutter/)
  * [Flutter helper widgets](https://github.com/angel-dart/flutter)

* Services
  * [Service Basics](services/service-basics.md)
  * [TypedService](services/typedservice.md)
  * [In-Memory](services/in-memory.md)
  * [Custom Services](services/custom-services.md)
  * [Hooks](services/hooks.md)
    * [Bundled Hooks](https://www.dartdocs.org/documentation/angel_framework/latest/angel_framework.hooks/angel_framework.hooks-library.html)
  * [Database-Agnostic Relations](https://github.com/angel-dart/relations)
  * Database Adapters
    * [MongoDB](https://github.com/angel-dart/mongo)
    * [RethinkDB](https://github.com/angel-dart/rethink)
    * [JSON File-based](https://github.com/angel-dart/file_service)

* Plug-ins
  * [Authentication](https://github.com/angel-dart/auth)
    * [Local](https://github.com/angel-dart/auth/wiki/Local-Auth)
    * [Google SSO](https://github.com/angel-dart/auth_google)
    * [Twitter SSO](https://github.com/angel-dart/auth_twitter)
    * [Instagram SSO](https://github.com/angel-dart/auth_instagram)
    * [OAuth2 \(generic\)](https://github.com/angel-dart/auth_oauth2)
    * [OAuth2 server implementation](https://github.com/angel-dart/oauth2)
  * [Configuration](https://github.com/angel-dart/configuration)
  * [Diagnostics & Logging](https://github.com/angel-dart/diagnostics)
  * [Reverse Proxy](https://github.com/angel-dart/proxy)
  * [Service Seeder](https://github.com/angel-dart/seeder)
  * [Static Files](https://github.com/angel-dart/static)
  * [Validation](https://github.com/angel-dart/validate)
  * [Websockets](https://github.com/angel-dart/websocket)
    * [WebSocket synchronization via `pub_sub`](https://github.com/angel-dart/sync)
  * [Server-sent Events](https://github.com/angel-dart/eventsource)
  * [Toggle-able Services](https://github.com/angel-dart/toggle)

* Middleware/Finalizers
  * [CORS](https://github.com/angel-dart/cors)
  * [Response Compression](https://github.com/angel-dart/compress)
  * [Security](https://github.com/angel-dart/security)
  * [File Upload Security](https://github.com/angel-dart/file_security)
  * [`shelf` Integration](https://github.com/angel-dart/shelf)
  * [User Agents](https://github.com/angel-dart/user_agent)
  * [Pagination](https://github.com/angel-dart/paginate)
  * [`Range`, `If-Range`, `Accept-Ranges` support](https://github.com/angel-dart/range)

* PostgreSQL ORM
  * [Model Serialization](https://github.com/angel-dart/serialize)
  * [Query Builder + ORM](https://github.com/angel-dart/orm)
  * [Migrations](https://github.com/angel-dart/migration)

* Deployment
  * [Running in Isolates](deployment/running-in-isolates.md)
  * [Configuring SSL](deployment/configuring-ssl.md)
  * [HTTP/2 Support](https://github.com/angel-dart/http2)
  * [Ubuntu and `nginx`](deployment/ubuntu-and-nginx.md)
  * [AppEngine](deployment/deployment-to-appengine.md)
  * [Production Mode](deployment/production-mode.md)

* Front-end
  * [Mustache Templates](https://github.com/angel-dart/mustache)
  * [Jael template engine](front-end/jael/README.md)
    * [Github](https://github.com/angel-dart/jael)
    * [Basics](front-end/jael/Basics.md)
    * [Custom Elements](front-end/jael/Custom-Elements.md)
    * [Strict Resolution](front-end/jael/Strict-Resolution.md)
    * [Directive: `declare`](front-end/jael/Directive:-declare.md)
    * [Directive: `for-each`](front-end/jael/Directive:-for-each.md)
    * [Directive: `extend`](front-end/jael/Directive:-extend.md)
    * [Directive: `if`](front-end/jael/Directive:-if.md)
    * [Directive: `include`](front-end/jael/Directive:-include.md)
    * [Directive: `switch`](front-end/jael/Directive:-switch.md)
  * [`compiled_mustache`-based engine](https://github.com/thislooksfun/angel_compiled_mustache)
  * [`html_builder`-based engine](https://github.com/angel-dart/html)
  * [Markdown template engine](https://github.com/angel-dart/markdown)
  * [Using Angel with Angular](https://dart.academy/using-angel-with-angular2/)

* Advanced
  * [API Documentation](http://www.dartdocs.org/documentation/angel_framework/latest)
  * [Contribute to Angel](https://github.com/angel-dart/angel)
  * [Production Utilities](https://github.com/angel-dart/production)
  * [Standalone Router](https://github.com/angel-dart/route)
  * [Writing a Plugin](advanced/writing-a-plugin.md)
  * [Task Engine](https://github.com/angel-dart/task)
  * [Hot Reloading](https://github.com/angel-dart/hot)
  * [Real-time polling](https://github.com/angel-dart/poll)
