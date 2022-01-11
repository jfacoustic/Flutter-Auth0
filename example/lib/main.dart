import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Auth0Credentials? _credentials;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final credentials = await FlutterAuth0.login(
                        clientId: dotenv.env["AUTH0_CLIENT_ID"],
                        domain: dotenv.env["AUTH0_DOMAIN"],
                        scope: "openid offline_access");
                    setState(() {
                      _credentials = credentials;
                    });
                  },
                  child: const Text("Login")),
              Text(_credentials?.accessToken ?? '')
            ],
          ),
        ),
      ),
    );
  }
}
