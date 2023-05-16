import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repository_pattern/core/utils/extensions.dart';

class GetCountries extends StatelessWidget {
  final void Function(dynamic res) callback;

  const GetCountries({
    super.key,
    required this.callback,
  });

  Future<void> getCountries() async {
    const endpoint = 'https://wft-geo-db.p.rapidapi.com/v1/geo/countries';
    final params = {'namePrefix': 'a'};
    final options = Options(
      headers: {
        'X-RapidAPI-Key': '814903cf5dmsh8c51a69ff86a9f5p1703d1jsn149cb7f015b2',
        'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
      },
    );

    try {
      final Response response = await Dio().get(
        endpoint,
        queryParameters: params,
        options: options,
      );

      if (response.statusCode == 200) {
        // callback(countryEntity);
      }
    } catch (e) {
      inspect(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.showNotification(message: 'Fetching countries...');

        getCountries();
      },
      child: const Text('Get countries'),
    );
  }
}
