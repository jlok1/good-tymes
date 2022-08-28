import 'package:flutter/material.dart';
import 'package:good_tymes/api/nominatim.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/address.dart';

class AddressSearch extends SearchDelegate<String> {
  AddressSearch(this.setCoordinates);
  final Function setCoordinates;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (query.isEmpty) {
          close(context, '');
        } else {
          query = '';
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Address>>(
      future: getAddresses(query),
      builder: (BuildContext context, AsyncSnapshot<List<Address>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final address = data[index].displayName;
              return ListTile(
                leading: const Icon(Icons.pin_drop),
                title: Text(address),
                onTap: () {
                  setCoordinates(data[index].latitude, data[index].longitude);
                  close(context, address);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(getText(context).somethingWentWrong),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
