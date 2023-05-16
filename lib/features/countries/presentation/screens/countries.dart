// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:repository_pattern/core/templates/layout.dart';
import 'package:repository_pattern/features/countries/data/repository/countries_repository.dart';
import 'package:repository_pattern/features/countries/domain/model/country.dart';

class Countries extends StatefulWidget {
  const Countries({super.key});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  @override
  Widget build(BuildContext context) {
    final countriesRepo =
        Provider.of<CountriesRepository>(context, listen: false);

    return Layout(
      child: FutureBuilder<List<Country>>(
        future: countriesRepo.getCountries(namePrefix: 'c'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: List.generate(
                snapshot.data!.length,
                (index) {
                  final country = snapshot.data![index];

                  return ListTile(
                    title: Text(
                      country.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            );
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
