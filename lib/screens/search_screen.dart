import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_field_autocomplete/search_field_autocomplete.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/screens/user_details_page.dart';

import '../models/user_data_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              List<UserDataModel> users = dataProvider.usersList;
              String currentUserId = FirebaseAuth.instance.currentUser!.uid;
              List<UserDataModel> filteredUsers =
                  users.where((user) => user.id != currentUserId).toList();
              return SearchFieldAutoComplete<UserDataModel>(
                placeholder: 'Search users',
                suggestions: filteredUsers
                    .map((user) => SearchFieldAutoCompleteItem<UserDataModel>(
                          user.fullname ?? '',
                          item: user,
                        ))
                    .toList(),
                suggestionsDecoration: SuggestionDecoration(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                autoCorrect: false,
                maxSuggestionsInViewPort: 3,
                onSuggestionSelected: (selectedItem) {
                  print("selected: ${selectedItem.searchKey}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => UserDetailsPage(
                                userId: selectedItem.item!.id,
                              )));
                  // Handle selected user
                },
                suggestionItemBuilder: (context, searchFieldItem) {
                  UserDataModel user = searchFieldItem.item!;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.url!),
                    ),
                    title: Text(user.fullname!),
                    subtitle: Text(user.email!),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
    ;
  }
}
