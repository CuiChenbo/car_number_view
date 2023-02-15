import 'package:flutter/material.dart';

import '../utils/color_res.dart';
import '../utils/screen_utils.dart';
import '../utils/string_utils.dart';
import 'carnumber_constants.dart';


//通过路由的方式打开
openCarNumberKeyboardRoute(BuildContext context , String? cn , CarNumberChanged carNumberChanged){
  Navigator.push(context, PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation){
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(animation),
        child: Scaffold(
            backgroundColor: Colors.black38,
            body: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: CarNumberKeyboard(cn ??'', carNumberChanged))),
      );

    },
  ));
}

typedef CarNumberChanged = Function(String carNumber , String value);


///车牌号格式键盘
class CarNumberKeyboard extends StatefulWidget {
  const CarNumberKeyboard(this.car_number , this.carNumberChanged , {Key? key}) : super(key: key);

  final CarNumberChanged carNumberChanged;
  final String car_number;

  @override
  State<CarNumberKeyboard> createState() => _CarNumberKeyboardState();
}

class _CarNumberKeyboardState extends State<CarNumberKeyboard> {

  final String mABC = "ABC";
  final String mProvince = "省份";
  final String mDelete = "<-";

  String carNumber = "";
  bool isInputABC = false;
  int maxCarNumberLength = 8;

  @override
  initState(){
    super.initState();
    carNumber = widget.car_number;
    isInputABC = carNumber.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    widget.carNumberChanged(carNumber , "完成");
                  },
                  child: Container(
                     alignment: AlignmentDirectional.center,
                      height: (42),
                      child: Text("完成",style: TextStyle(color: color_00131D , fontSize: (16)),)),
                ),
              ],
            ),
          ),
          Container(
            color: color_f6f6f6,
            width: ScreenUtils.getScreenWidth(context),
            padding: EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getCarNumberKeyView(isInputABC ? carnumber_numbers : carnumber_provinces_list[0]),
                getCarNumberKeyView(isInputABC ? carnumber_alphabets[0]: carnumber_provinces_list[1]),
                getCarNumberKeyView(isInputABC ? carnumber_alphabets[1]: carnumber_provinces_list[2]),
                getCarNumberKeyView(isInputABC ? carnumber_alphabets[2] : carnumber_provinces_list[3], isEnd: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getCarNumberKeyView(List<String> datas , {bool isEnd = false}){

    List<Widget> views = [];
    if(isEnd) views.add(Expanded(child: carNumberKeyView(isInputABC ? mProvince : mABC , backColor: color_DADBDC)));
    datas.forEach((e) {
      views.add(carNumberKeyView(e));
    });
    if(isEnd) views.add(Expanded(child: carNumberKeyView(mDelete , backColor: color_DADBDC)));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: views,
    );

  }

  Widget carNumberKeyView(String text , {backColor = color_fff} ){
    return InkWell(
      onLongPress: (){
        print('onLongPress');
      },
      onTap: (){
        setState(() {
          if (text == "I") {
            print('车牌号中不存在I');
            //车牌号中不存在I
          } else if (text == mABC || text == mProvince) {
            isInputABC = !isInputABC;
          } else if (text == mDelete) {
            carNumber = carNumber.substring(
                0, carNumber.isNotEmpty ? carNumber.length - 1 : 0);
            if (carNumber.isEmpty) isInputABC = false; //自动切换省份or字母逻辑
          } else if (carNumber.length < maxCarNumberLength) {
            carNumber += text;
            isInputABC = true; //自动切换省份or字母逻辑
          }
        });
        widget.carNumberChanged(carNumber , text);

      },
      child: SizedBox(
        height: (48),
        width: ScreenUtils.getScreenWidth(context)/10,
        child: Card(
          elevation: .8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          margin: const EdgeInsets.fromLTRB(2, 3, 2, 3),
          color: backColor,
          child: Container(
            alignment: AlignmentDirectional.center,
            height: double.infinity,
            width: double.infinity,
            child: text == mDelete ?
            Image.asset("lib/images/icon_rollback.png" , width: 23 , height: 17,):
            Text(text, style:
              TextStyle(color: text == 'I' ? Color(0XFFB7BABC) : color_00131D
                  , fontSize: (18)),
            ),
          ),
        ),
      ),
    );
  }
}
