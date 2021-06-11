import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> horizontalAnimation;
  late final Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(controller);

    horizontalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.2,
          0.8,
          curve: Curves.linear,
        ),
      ),
    );

    controller.forward();
  }

  void toggleAnimation() {
    if (controller.isCompleted)
      controller.reverse();
    else {
      if (controller.isDismissed) {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: toggleAnimation,
        child: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Container(
                color: colorAnimation.value,
                child: Stack(
                  children: [
                    child!,
                    Positioned(
                      top: size.height * 0.2,
                      left: size.width * 0.25 +
                          ((controller.value * 0.25) * size.width),
                      height: size.height * 0.6,
                      width: size.width * 0.25,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Stack(
                          children: [
                            //Instead try to use blendMode src.
                            //Adicionar um container transparente após o container branco e setar um blendMode onde ele se
                            //sobreponha aos formulários caso eles estejam acima dele.
                            ClipRect(
                              clipper: FormsClipper(),
                              child: Transform.translate(
                                offset: Offset(
                                  -size.width * 0.5 * horizontalAnimation.value,
                                  0,
                                ),
                                child: SignInForm(
                                    toggleAnimation: toggleAnimation),
                              ),
                            ),
                            ClipRect(
                              clipper: FormsClipper(),
                              child: Transform.translate(
                                offset: Offset(
                                  // size.width * 0.5 * controller.value,
                                  size.width *
                                      0.5 *
                                      (1 - horizontalAnimation.value),
                                  0,
                                ),
                                child: SignUpForm(
                                    toggleAnimation: toggleAnimation),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    backgroundBlendMode: BlendMode.softLight,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an Account?',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: size.height * 0.01),
                            ElevatedButton(
                              onPressed: toggleAnimation,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an Account?',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: size.height * 0.01),
                            ElevatedButton(
                              onPressed: toggleAnimation,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  SignInForm({
    required this.toggleAnimation,
  }) : super(key: UniqueKey());

  final Function toggleAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, bc) => Center(
        child: SizedBox(
          width: bc.maxWidth,
          height: bc.maxHeight,
          child: Column(
            children: [
              Spacer(flex: 4),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        toggleAnimation();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  SignUpForm({
    required this.toggleAnimation,
  }) : super(key: UniqueKey());

  final Function toggleAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, bc) => Center(
        child: SizedBox(
          width: bc.maxWidth,
          height: bc.maxHeight,
          child: Column(
            children: [
              Spacer(flex: 4),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bc.maxHeight * 0.02),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        toggleAnimation();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class FormsClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    //Todo: improve this.
    return false;
  }
}
