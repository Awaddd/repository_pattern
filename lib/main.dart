import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:repository_pattern/core/utils/color_schemes.g.dart';
import 'package:repository_pattern/core/utils/typography.dart';
import 'package:repository_pattern/features/countries/data/network/client/api_client.dart';
import 'package:repository_pattern/features/countries/data/network/network_mapper.dart';
import 'package:repository_pattern/features/countries/data/repository/countries_repository.dart';
import 'package:repository_pattern/features/countries/domain/model/config.dart';
import 'package:repository_pattern/features/countries/presentation/screens/countries.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await _createData();
  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  final InitialData data;

  const MyApp({required this.data});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: textTheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: textTheme,
        ),
        themeMode: ThemeMode.light,
        home: const Countries(),
      ),
    );
  }
}

class InitialData {
  final List<SingleChildWidget> providers;

  InitialData({required this.providers});
}

Future<InitialData> _createData() async {
  // Util

  final log = Logger(
    printer: PrettyPrinter(),
    level: kDebugMode ? Level.verbose : Level.nothing,
  );

  // load project configuration
  final config = await _loadConfig(log);

  // Data
  final apiClient = ApiClient(
    baseUrl: 'https://wft-geo-db.p.rapidapi.com/v1/geo/',
    apiKey: config.apiKey,
    apiHost: config.apiHost,
  );

  final networkMapper = NetworkMapper(log: log);

  final countriesRepo = CountriesRepository(
    apiClient: apiClient,
    networkMapper: networkMapper,
  );

  // Create and return list of providers
  return InitialData(
    providers: [
      Provider<Logger>.value(value: log),
      Provider<CountriesRepository>.value(value: countriesRepo),
    ],
  );
}

Future<Config> _loadConfig(Logger log) async {
  String raw;

  try {
    raw = await rootBundle.loadString('assets/config/config.json');

    final config = json.decode(raw) as Map<String, dynamic>;

    return Config(
      apiKey: config['apiKey'] as String,
      apiHost: config['apiHost'] as String,
    );
  } catch (e) {
    log.e(
      'Error while loading project configuration, please make sure '
      'that the file located at /assets/config/config.json '
      'exists and that it contains the correct configuration',
      e,
    );
    rethrow;
  }
}
