// @dart=v2.9

import 'dart:io';

import 'package:args/args.dart';
import 'package:codemod/codemod.dart';
import 'package:glob/glob.dart';
import 'package:openapi_migrate/openapi_suggestor.dart';
import 'package:yaml/yaml.dart';

main(List<String> passedArgs) async {
  var argParser = ArgParser();

  argParser.addOption('api');
  argParser.addOption('glob');
  argParser.addMultiOption('f');

  ArgResults args = argParser.parse(passedArgs);

  String openapiFile = args['api'];
  if (openapiFile == null) {
    print(
        "You must specify the location of the openapi file with --api <filename>");
    return;
  }

  final f = await File(openapiFile);
  if (!(await f.exists())) {
    print("No api file called ${openapiFile} exists");
    return;
  }

  String contents = await f.readAsString();

  final api = loadYaml(contents);

  final schema = api['components']['schemas'] as YamlMap;

  openapiClasses = schema.keys.map((e) => e.toString()).toList();

  if (openapiClasses.isEmpty) {
    print("There are no components schemas in the OpenAPI file.");
    return;
  }

  String glob = args['glob'];

  var processed = false;
  if (glob != null) {
    processed = true;
    print("processing glob ${glob}");
    await runInteractiveCodemod(
        filePathsFromGlob(Glob(glob, recursive: true)), OpenApiPatchSuggestor(),
        args: []);
  }

  if (args['f'] != null) {
    processed = true;
    await runInteractiveCodemod(
        args['f'] as Iterable<String>, OpenApiPatchSuggestor(),
        args: []);
  }

  if (!processed) {
    await runInteractiveCodemod(['pubspec.yml'], OpenApiPatchSuggestor(),
        args: []);
  }
}
