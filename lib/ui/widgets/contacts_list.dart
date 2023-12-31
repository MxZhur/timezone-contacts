import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone_contacts/data/repositories/repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './contacts_list_item.dart';
import '../../data/models/contact.dart';

class ContactsList extends StatefulWidget {
  final Location? referenceTimeZone;
  final DateTime? referenceTime;

  const ContactsList({
    super.key,
    this.referenceTimeZone,
    this.referenceTime,
  });

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  String searchQuery = '';

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int minContactsToRenderSearchField = 10;

    final repository = Provider.of<Repository>(context, listen: false);

    return StreamBuilder<List<Contact>>(
      stream: repository.watchAllContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final contactsRaw = snapshot.data!;

        var contacts = contactsRaw;

        if (searchQuery.trim().isNotEmpty) {
          contacts = contacts
              .where((element) =>
                  element.name.toLowerCase().contains(searchQuery.trim()))
              .toList();
        }

        return Column(
          children: [
            if (contactsRaw.length >= minContactsToRenderSearchField)
              buildSearchField(),
            Expanded(
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 5)),
                builder: (context, snapshot) {
                  if (contacts.isEmpty) {
                    return Center(
                      child: Opacity(
                        opacity: 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.contacts,
                              size: 75.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.messageNoContactsFound,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return ContactsListItem(
                        contact: contact,
                        referenceTimeZone: widget.referenceTimeZone,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5.0),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                });
                searchController.text = value;
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.hintSearch,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: const EdgeInsets.only(
                  top: 0.0,
                  bottom: 0.0,
                  left: 10.0,
                  right: 5.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
