import 'package:flutter/material.dart';

@immutable
class ClockButton extends StatelessWidget {
  const ClockButton({
    Key? key,
    required this.clockIcon,
    required this.onTap,
    required this.colors,
    required this.text,
  }) : super(key: key);

  final IconData clockIcon;
  final Function() onTap;
  final List<Color> colors;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: colors[0].withAlpha(5),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: colors[0].withAlpha(20),
        ),
        child: GestureDetector(
          // splashFactory: NoSplash.splashFactory,
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  clockIcon,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 4,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
