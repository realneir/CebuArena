import 'package:captsone_ui/Screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({Key? key}) : super(key: key);

  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmailPasswordLogin()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                // you need to wrap your state changes in setState method
                if (bookmarked == false) {
                  bookmarked = true;
                  _controller.forward();
                } else {
                  bookmarked = false;
                  _controller.reverse();
                }
              });
            },
            child: Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_xvqam5qh.json',
                controller: _controller),
          ),
        ));
  }
}
