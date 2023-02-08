import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone_contacts/ui/screens/screens.dart';
import '../../misc/constants.dart' as constants;
import '../widgets/contacts_list.dart';
import '../widgets/my_local_time_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.appName),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactFormScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.person_add,
                  size: 26.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'settings':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                    break;
                  case 'about':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return const [
                  PopupMenuItem(
                    value: 'settings',
                    child: Text("Settings"),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    child: Text("About"),
                  )
                ];
              },
            ),

            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const SettingsScreen(),
            //       ),
            //     );
            //   },
            //   child: const Icon(Icons.settings),
            // ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FlutterNativeTimezone.getLocalTimezone(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final currentTimeZone = snapshot.data!;

          var userLocation = tz.getLocation(currentTimeZone);

          tz.setLocalLocation(userLocation);

          return Column(
            children: [
              MyLocalTimePanel(
                referenceTimeZone: userLocation,
              ),
              Expanded(
                child: ContactsList(
                  referenceTimeZone: userLocation,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
