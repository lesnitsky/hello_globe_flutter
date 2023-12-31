import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> helloGlobe() async {
  final response = await get(Uri.parse('https://hello.globeapp.dev'));
  return response.body;
}

void main() {
  // ignore: avoid_print
  helloGlobe().then((value) => print(value));
  runApp(const HelloGlobeApp());
}

class HelloGlobeApp extends StatelessWidget {
  const HelloGlobeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xff000000),
      builder: (context, widget) {
        return const ColoredBox(
          color: Color(0xff000000),
          child: Home(),
        );
      },
    );
  }
}

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool hovered = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: switch ((hovered, pressed)) {
              (_, true) => const Color.fromARGB(255, 44, 44, 44),
              (true, false) => const Color.fromARGB(255, 64, 64, 64),
              _ => const Color.fromARGB(255, 32, 32, 32),
            },
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(255, 44, 44, 44),
              width: 2,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color:
                  hovered ? const Color(0xffffffff) : const Color(0xffffffff),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String response = '';
  Duration duration = const Duration(seconds: 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                  text: 'Hello, Globe!',
                  onPressed: () {
                    final stopwatch = Stopwatch()..start();
                    helloGlobe().then((value) {
                      setState(() {
                        duration = stopwatch.elapsed;
                        response = value;
                        stopwatch.stop();
                      });
                    }).catchError((error) {
                      setState(() {
                        duration = stopwatch.elapsed;
                        response = error.toString();
                        stopwatch.stop();
                      });
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: response.isNotEmpty
                      ? Text(
                          'Globe says: ${response.replaceAll('\n', '')} (took ${duration.inMilliseconds}ms)',
                          style: const TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(height: 14 * 1.2),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Powered by ',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: 'Globe.dev',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(Uri.parse('https://globe.dev')),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 59, 239, 255),
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
