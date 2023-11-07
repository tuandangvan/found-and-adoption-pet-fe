import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  //Hàm callback onEnd sẽ được gọi khi animation kết thúc (onEnd chứa các lệnh để thực thi sau khi kết thúc animation)
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation(
      {super.key,
      required this.child,
      required this.isAnimating,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd,
      this.smallLike = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

//đồng bộ hóa Animation với vòng đời của Widget
class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    
    //thay đổi kích thước tỉ lệ ảnh từ 100% -> 120%
    scale =Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
  }

  startAnimation() async{
    if(widget.isAnimating || widget.smallLike){

      //animation chạy từ đầu -> cuối
      await controller.forward();

      //animation chạy từ cuối -> đầu
      await controller.reverse();

      await Future.delayed(const Duration(milliseconds: 200,));

      if(widget.onEnd !=null){
        widget.onEnd!();
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //sử dụng ScaleTransition để áp dụng hiệu ứng thay đổi kích thước scale lên widget 'child'
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
