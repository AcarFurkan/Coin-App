import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TyperText extends StatelessWidget {
  final String text;
  const TyperText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 30.0,
          fontFamily: 'Bobbers',
        ),
        child: AnimatedTextKit(animatedTexts: [
          TyperAnimatedText(text,
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center),
          TyperAnimatedText(text,
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class TypeWriter extends StatelessWidget {
  final String text;
  TypeWriter({Key? key, required this.text, this.colorScheme})
      : super(key: key);
  ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 30.0,
          fontFamily: 'Agne',
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            TypewriterAnimatedText(text,
                textStyle: TextStyle(
                    color: colorScheme == null
                        ? Colors.green
                        : colorScheme!.secondaryVariant),
                speed: const Duration(milliseconds: 100),
                textAlign: TextAlign.center),
            TypewriterAnimatedText(text,
                textStyle: TextStyle(
                    color: colorScheme == null
                        ? Colors.green
                        : colorScheme!.primaryVariant),
                speed: const Duration(milliseconds: 100),
                textAlign: TextAlign.center),
          ],
          onTap: () {},
        ),
      ),
    );
  }
}

class Scale extends StatelessWidget {
  final String text;
  const Scale({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 70.0,
          fontFamily: 'Canterbury',
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            ScaleAnimatedText(
              text,
            ),
            ScaleAnimatedText(
              text,
            ),
            ScaleAnimatedText(
              text,
            ),
          ],
          onTap: () {},
        ),
      ),
    );
  }
}

class Wavy extends StatelessWidget {
  final String text;
  const Wavy({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20.0,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(text,
                speed: const Duration(milliseconds: 100),
                textAlign: TextAlign.center),
            WavyAnimatedText(text,
                speed: const Duration(milliseconds: 100),
                textAlign: TextAlign.center),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
          onTap: () {},
        ),
      ),
    );
  }
}
