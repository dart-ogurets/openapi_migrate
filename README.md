# OpenAPI Migrate

This is intended to help developers migrate from 4.2 and earlier versions of the Dart OpenAPI compiler to  the 5.0 and later versions.

These versions did not include a way to pass the fields during construction of the object and it turns out, for
null safety this is very important.

If your code follows the general pattern:

new ModelClass()
  ..field1 = x
  ..field2 = y;

then this package will walk through your source code and migrate this code to 

ModelClass(field1: x, field2: y)

It will only do this for classes listed in your API, and it may require you to run it multiple times as it replaces
code which itself may have this pattern embedded in it. It is worthwhile to keep running the command until it doesn't
trigger any further matches.

## Installing from source:

```bash
pub global activate --source path .
```

Installing from pub.dev:

```bash
pub global activate openapi_migrate
```

## Use

```bash
pub run openapi_migrate
```

Extra parameters are:

*  `--api api.yaml` - specify the API to use. This is required and it will fail without it, and it must have a component schema. You can iterate over your code with multiple YAML files.
*  `--f filename` - this is repeating, if it exists it will process this file. You can specify multiple files
*  `--glob pattern` - this specifies a recursive pattern to look for given the current directory

The replacement is interactive and you can combine the filename and glob patterns. If you don't specify either then
it will look for and load the pubspec.yaml file and proceed to go over all files.

## Thanks

This is the product of http://featurehub.io[FeatureHub / Anyways Labs] who do all of the work around OpenAPI Dart and Ogurets.

This migration is made possible because of the excellent https://pub.dev/packages/codemod[`codemoc`] project. 



