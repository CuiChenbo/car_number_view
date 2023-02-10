import 'package:car_number_view/car_number/carnumber_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_res.dart';

//通过路由的方式打开
openAddCarNumberRoute(BuildContext context) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return AddCarnumberPage();
  }));
}

class AddCarnumberPage extends StatefulWidget {
  const AddCarnumberPage({Key? key}) : super(key: key);

  @override
  State<AddCarnumberPage> createState() => _AddCarnumberPageState();
}

class _AddCarnumberPageState extends State<AddCarnumberPage> with SingleTickerProviderStateMixin{
  Widget LineCuttingHorizontal({colorLine = color_E5E5E5}) {
    return Container(
      height: (.5),
      width: double.infinity,
      color: colorLine,
    );
  }

  var _carController = TextEditingController();
  var showKeyboard = false;


  AnimationController? _animationController;
  Animation<Offset>? _animation;
  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween( begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),).animate(_animationController!);



    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加车牌号"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: (52),
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Text(
                        "号牌种类",
                        style: TextStyle(fontSize: (14), color: color_636E85),
                      ),
                      SizedBox(
                        width: (86),
                      ),
                      Text(
                        "机动车",
                        style: TextStyle(fontSize: (14), color: color_00131D),
                      ),
                    ],
                  ),
                ),
                LineCuttingHorizontal(),
                Container(
                  height: (52),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "号牌号码",
                        style: TextStyle(fontSize: (14), color: color_636E85),
                      ),
                      SizedBox(
                        width: (86),
                      ),
                      Expanded(
                        child: TextField(
                          onTap: () {
                            setState(() {
                              showKeyboard = true;
                              _animationController?.forward();
                            });
                          },
                          readOnly: true,
                          showCursor: true,
                          cursorColor: color_00131D,
                          controller: _carController,
                          maxLines: 1,
                          style: const TextStyle(
                            height: 1.5,
                            fontSize: (14),
                            color: color_00131D,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: "请输入号牌号码",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: color_8F9296,
                              fontSize: (14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                LineCuttingHorizontal(),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: SlideTransition(
                  position: _animation!,
                  child: CarNumberKeyboard((n, t) {
                    if (t == "完成") {
                      setState(() {
                        showKeyboard = false;
                        _animationController?.reverse();
                      });
                    }
                    _carController.value = TextEditingValue(
                        text: n,
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: n.length)));
                  }),
                ),
          ),
        ],
      ),
    );
  }

}
