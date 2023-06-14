import 'package:flutter/material.dart';

class AnimatedBottomSheet extends StatefulWidget {
  const AnimatedBottomSheet(
      {Key? key,
      required this.child,
      required this.title,
      required this.buildContext})
      : super(key: key);

  final Widget child;
  final String title;
  final BuildContext buildContext;

  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(
          () {
            _opacity = 1;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _opacity,
      child: Padding(
        padding: MediaQuery.of(widget.buildContext).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black87,
                      child: Icon(
                        Icons.close,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            widget.child,
          ],
        ),
      ),
    );
  }
}
