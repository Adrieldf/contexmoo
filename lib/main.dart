import 'package:contexmoo/constants/theme.dart';
import 'package:contexmoo/webpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contexmoo',
      theme: mainTheme,
      home: const MyHomePage(title: 'Contexmoo'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('pt', 'br'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int endTime = 0;

  void getEndTime() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        endTime = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1, 0)
            .millisecondsSinceEpoch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: mainTheme.colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)?.timeLeftToRefresh ??
                        "Time left to refresh: ",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  CountdownTimer(
                    endTime: endTime,
                    onEnd: getEndTime,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WebPage(
                                name: "Term.ooo",
                                link: "https://term.ooo",
                              )),
                    ),
                    child: const Text("Term.ooo"),
                    style: ElevatedButton.styleFrom(
                        primary: mainTheme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WebPage(
                              name: "Contexto.me",
                              link: "https://contexto.me")),
                    ),
                    child: const Text("Contexto.me"),
                    style: ElevatedButton.styleFrom(
                        primary: mainTheme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
