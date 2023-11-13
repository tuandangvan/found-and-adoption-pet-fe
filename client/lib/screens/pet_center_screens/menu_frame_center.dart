import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/screens/menu_screen.dart';

class MenuFrameCenter extends StatefulWidget {
  const MenuFrameCenter({super.key});

  @override
  State<MenuFrameCenter> createState() => _MenuFrameCenterState();
}

class _MenuFrameCenterState extends State<MenuFrameCenter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Duration duration = Duration(microseconds: 200);
  // late Animation<double> scaleAnimation, smallerScaleAnimation;
  bool menuOpen = true;
  late List<Animation<double>> scaleAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);

    // scaleAnimation =
    //     Tween<double>(begin: 1.0, end: 0.7).animate(_animationController);

    // smallerScaleAnimation =
    //     Tween<double>(begin: 1.0, end: 0.6).animate(_animationController);

    scaleAnimations = [
      Tween<double>(begin: 1.0, end: 0.7).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.6).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.5).animate(_animationController),
    ];

    //hoạt ảnh chạy từ begin -> end
    _animationController.forward();

    //sao chép danh sách screens vào screensnapshot
    screenSnapshot = screens.values.toList();
  }

  //Map chứa cặp key-value (int - widget)
  Map<int, Widget> screens = {
    0: AdoptionScreen(),
    1: FeedScreen(),
    2: EditProfileCenterScreen(),
  };

  late List<Widget> screenSnapshot;

  List<Widget> finalStack() {
    List<Widget> stackToReturn = [];
    stackToReturn.add(MenuScreen(
      menuCallBack: (selectedIndex) {
        setState(() {
          screenSnapshot = screens.values.toList();
          final selectedWidget = screenSnapshot.removeAt(selectedIndex);

          //chèn screen được chọn lên vtri đầu tiên
          screenSnapshot.insert(0, selectedWidget);
        });
      },
    ));

    screenSnapshot
        //Map chứa key-value. Trong đó key(vitri màn hình), value (màn hình tương ứng)
        .asMap()
        .entries
        .map((screenEntry) => buildScreenStack(screenEntry
            .key)) //gọi đến buildScreenStack để tạo widget tương ứng với key (int)
        .toList()
        .reversed
        .forEach((screen) {
      stackToReturn.add(screen);
    });

    return stackToReturn;
  }

  Widget buildScreenStack(int position) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        left: menuOpen ? deviceWidth * 0.55 - (position * 50) : 0.0,
        right: menuOpen ? deviceWidth * -0.45 + (position * 50) : 0.0,
        bottom: 0,
        child: ScaleTransition(
            scale: scaleAnimations[position],
            //wiget này đc sử dụng xử lý thao tac chạm như kéo, vuốt, nhấn giữ,...
            child: GestureDetector(
              onTap: () {
                if (menuOpen) {
                  setState(() {
                    menuOpen = false;

                    //hoạt ảnh chạy ngược từ end -> begin
                    _animationController.reverse();
                  });
                }
              },
              child: AbsorbPointer(
                absorbing: menuOpen,
                child: Material(
                    animationDuration: duration,
                    borderRadius: BorderRadius.circular(menuOpen ? 40 : 0),
                    child: screenSnapshot[position]),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(children: finalStack());
  }
}