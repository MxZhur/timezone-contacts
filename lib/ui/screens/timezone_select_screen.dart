import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone_contacts/misc/functions.dart';
import 'package:timezone_contacts/ui/widgets/time_display.dart';

class TimezoneSelectScreen extends StatefulWidget {
  final Function(String value) onSelect;

  const TimezoneSelectScreen({
    super.key,
    required this.onSelect,
  });

  @override
  State<TimezoneSelectScreen> createState() => _TimezoneSelectScreenState();
}

class _TimezoneSelectScreenState extends State<TimezoneSelectScreen> {
  int? filterOffset;

  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locations = tz.timeZoneDatabase.locations.values.toList();

    locations.sort(
      (a, b) => a.currentTimeZone.offset.compareTo(b.currentTimeZone.offset),
    );

    List<int?> allOffsets = [null];

    allOffsets.addAll(locations
        .map(
          (e) => e.currentTimeZone.offset,
        )
        .toSet());

    if (filterOffset != null) {
      locations = locations
          .where((element) => element.currentTimeZone.offset == filterOffset)
          .toList();
    }

    if (searchQuery.trim() != '') {
      locations = locations.where(
        (element) {
          var slashPos = element.name.lastIndexOf('/');
          String locationGroupName = (slashPos != -1)
              ? element.name.substring(0, slashPos)
              : element.name;
          locationGroupName = locationGroupName.replaceAll('_', ' ');

          String locationName = (slashPos != -1)
              ? element.name.substring(slashPos + 1)
              : element.name;
          locationName = locationName.replaceAll('_', ' ');

          return locationName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase().trim()) ||
              locationGroupName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase().trim());
        },
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.titleSelectTimeZone,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildSearchField(),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton<int?>(
                    hint: Text(
                      AppLocalizations.of(context)!.labelUtcOffset,
                    ),
                    isExpanded: true,
                    value: filterOffset,
                    items: allOffsets.map((int? value) {
                      if (value == null) {
                        return DropdownMenuItem<int?>(
                          value: value,
                          child: Text(
                            AppLocalizations.of(context)!.optionAllOffsets,
                          ),
                        );
                      }

                      return DropdownMenuItem<int?>(
                        value: value,
                        child: Text(locationOffsetToString(value)),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        filterOffset = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final location = locations[index];

                    return buildLocationItem(context, location);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5.0);
                  },
                  itemCount: locations.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocationItem(BuildContext context, tz.Location location) {
    final DateTime displayTime = tz.TZDateTime.now(location);

    var slashPos = location.name.lastIndexOf('/');
    String locationGroupName =
        (slashPos != -1) ? location.name.substring(0, slashPos) : location.name;
    locationGroupName = locationGroupName.replaceAll('_', ' ');

    String locationName = (slashPos != -1)
        ? location.name.substring(slashPos + 1)
        : location.name;
    locationName = locationName.replaceAll('_', ' ');

    final offsetText = locationOffsetToString(location.currentTimeZone.offset);

    return GestureDetector(
      onTap: () {
        widget.onSelect(location.name);

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      locationGroupName,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      offsetText,
                    ),
                  ),
                ],
              ),
              TimeDisplay(
                time: displayTime,
                fontSize: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      searchQuery = '';
                    });
                    searchController.text = '';
                  },
                  child: const Icon(Icons.backspace),
                ),
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
