Interactive Web applications typically require some type of user input (whether that user is a human,
machine, or otherwise is irrelevant). Galileo features built-in support for parsing request bodies with the
following content types:
* `application/x-www-form-urlencoded`
* `application/json`
* `multipart/form-data`

## Parsing the body
All you need to do to parse a request body is call `RequestContext.parseBody`. This method
is idempotent, and only ever performs the body-parsing logic once, so it is recommended to call
it any time you access the request body, unless you are 100% sure that it has been parsed before.

You can access the body as a `Map`, `List`, or `Object`, depending on your use case:

```dart
app.post('/my_form', (req, res) async {
    // Parse the body, if it has not already been parsed.
    await req.parseBody();

    // Access fields from the body, which is the most common use case.
    var userId = req.bodyAsMap['user_id'] as String;

    // If the user posted a List, i.e., through JSON:
    var count = req.bodyAsList.length;

    // To access the body, regardless of its runtime type:
    var objectBody = req.bodyAsObject as SomeType;
});
```

## Handling File Uploads
In the case of `multipart/form-data`, Galileo will also populate the `uploadedFiles` field.
The `UploadedFile` wrapper class provides mechanisms for reading content types, metadata, and
accessing the contents of an uploaded file as a `Stream<List<int>>`:

```dart
app.post('/upload', (req, res) async {
    await req.parseBody();

    var file = req.uploadedFiles.first;

    if (file.contentType.type == 'video') {
        // Write directly to a file.
        await file.data.pipe(someFile.openWrite());
    }
});
```

## Custom Body Parsing
You can handle other content types by manually parsing the body.
You can set `bodyAsObject`, `bodyAsMap`, or `bodyAsList` exactly
once:

```dart
Future<void> unzipPlugin(Galileo app) async {
    app.fallback((req, res) async {
        if (!req.hasParsedBody
            && req.contentType.mimeType == 'application/zip') {
            var archive = await decodeZip(req.body);
            var fields = <String, dynamic>{};

            for (var file in archive.files) {
                fields[file.path] = file.mode;
            }

            req.bodyAsMap = fields;
        }

        return true;
    });
}
```

If the user did not provide a `content-type` header when `parseBody` is called, a `400 Bad Request` error
will be thrown.
