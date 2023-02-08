import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const year = 2023;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset(
              'assets/tzc_logo.png',
              height: 128,
            ),
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final packageInfo = snapshot.data!;

              return Column(
                children: [
                  Center(
                    child: Text(
                      packageInfo.appName,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Version ${packageInfo.version} (${packageInfo.buildNumber})',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Center(
                    child: Text(
                      '(c) $year Maxim Zhuravlev',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
