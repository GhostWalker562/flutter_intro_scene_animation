import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedIntroScene extends StatefulWidget {
  const AnimatedIntroScene({
    Key? key,
    this.child,
    required this.upperText,
    required this.centerText,
    required this.lowerText,
  }) : super(key: key);

  final Widget? child;
  final String upperText, centerText, lowerText;

  @override
  _AnimatedIntroSceneState createState() => _AnimatedIntroSceneState();
}

enum IntroProps { canvasOffset, upperOffset, centerOffset, bottomOffset }

class _AnimatedIntroSceneState extends State<AnimatedIntroScene> {
  final TimelineTween<IntroProps> _timelineTween = TimelineTween<IntroProps>();

  // Constant tweens
  final Tween<Offset> _reveal =
      Tween<Offset>(begin: Offset(0, 1), end: Offset.zero);
  final Tween<Offset> _disappear =
      Tween<Offset>(end: Offset(0, 1), begin: Offset.zero);

  @override
  void initState() {
    // We do this in initState because when can use the initialization of _reveal and _disappear 
    _timelineTween
        // Reveal center text
        .addScene(
            begin: Duration.zero,
            duration: Duration(seconds: 1),
            curve: Curves.easeOutExpo)
        .animate(IntroProps.centerOffset, tween: _reveal)
        // Reveal upper and bottom text
        .addSubsequentScene(
            duration: Duration(seconds: 1),
            delay: Duration(milliseconds: 250),
            curve: Curves.easeOutExpo)
        .animate(IntroProps.bottomOffset, tween: _reveal)
        .animate(IntroProps.upperOffset, tween: _reveal)
        // Return all text and disappear the canvas
        .addSubsequentScene(
            duration: Duration(seconds: 1),
            delay: Duration(milliseconds: 250),
            curve: Curves.easeOutExpo)
        .animate(IntroProps.canvasOffset, tween: _disappear)
        .animate(IntroProps.bottomOffset,
            tween: _disappear, shiftEnd: Duration(milliseconds: 500))
        .animate(IntroProps.centerOffset,
            tween: _disappear, shiftEnd: Duration(milliseconds: 500))
        .animate(IntroProps.upperOffset,
            tween: _disappear, shiftEnd: Duration(milliseconds: 500));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayAnimation<TimelineValue<IntroProps>>(
        tween: _timelineTween,
        duration: _timelineTween.duration,
        builder: (context, child, value) {
          return Stack(
            children: [
              if (child != null) child,
              
              // Upper text
              FractionalTranslation(
                translation: value.get(IntroProps.canvasOffset),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color(0xFFCDB8EF),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: FractionalTranslation(
                    translation: value.get(IntroProps.upperOffset),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.upperText,
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),


              // Center text
              Align(
                alignment: Alignment.center,
                child: ClipRect(
                  child: FractionalTranslation(
                    translation: value.get(IntroProps.centerOffset),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.centerText,
                        style: Theme.of(context)
                            .accentTextTheme
                            .headline1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom text
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: FractionalTranslation(
                    translation: value.get(IntroProps.bottomOffset),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.lowerText,
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
