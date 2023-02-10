import 'package:flutter/material.dart';

import '../utils/color_res.dart';
import '../utils/screen_utils.dart';
import '../utils/string_utils.dart';
import 'carnumber_constants.dart';


openCarNumberViewDialog(BuildContext context , String carNumber){
  showModalBottomSheet(context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      builder: (w){
    return CarNumberViewView();
  });
}
//通过路由的方式打开
openCarNumberViewRoute(BuildContext context , String carNumber){
  Navigator.push(context, PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation){
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(animation),
        child: const Scaffold(
            backgroundColor: Colors.black38,
            body: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: CarNumberViewView())),
      );

    },
  ));
}

///车牌号数据框+车牌号键盘-底部弹框
class CarNumberViewView extends StatefulWidget {
  const CarNumberViewView({Key? key}) : super(key: key);

  @override
  State<CarNumberViewView> createState() => _CarNumberViewViewState();
}

class _CarNumberViewViewState extends State<CarNumberViewView> {

  final String mABC = "ABC";
  final String mProvince = "省份";
  final String mDelete = "<-";

  String carNumber = "";
  bool isInputABC = false;
  int maxCarNumberLength = 8;


  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtils.getScreenWidth(context),
        height: (380),
        decoration: const BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5) , topRight: Radius.circular(5) ,)
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.keyboard_arrow_down_outlined , color: Color(0XFF6A6E74), size: (24),)),
                  Text("编辑车牌" , style: TextStyle(color: color_00131D , fontSize: (16)),),
                  InkWell(
                    onTap: carNumber.length > 6 ?(){
                      Navigator.pop(context);
                    } : null,
                    child: Container(
                       alignment: AlignmentDirectional.center,
                        height: (56),
                        child: Text("确定",style: TextStyle(color: carNumber.length > 6 ? color_00131D : color_8F9296 , fontSize: (16)),)),
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: (92),
              width: ScreenUtils.getScreenWidth(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: getCarNumberInputView(),
              ),
            ),
            Expanded(
              child: Container(
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
            ),
          ],
        ),
    );
  }

  List<Widget> getCarNumberInputView(){
    var carNumbers = StringUtils.stringToStringList(carNumber);

    List<Widget> views = [];
    for(int i = 0; i < maxCarNumberLength ; i++){
      if(carNumbers.length > i){
        views.add(carNumberInputView(carNumbers[i] , borderSelect: carNumbers.length == i, marginLeft: i==0 ? 0 : i == 2 ? 24 : 8));
      }else{
        views.add(carNumberInputView('' ,  borderSelect: carNumbers.length == i, marginLeft: i==0 ? 0 : i == 2 ? 24 : 8));
      }
    }
    return views;
  }

  Widget carNumberInputView(String? text , {borderSelect = false , double marginLeft = 8}){
    return Container(
      margin: EdgeInsets.only(left: (marginLeft)),
      alignment: AlignmentDirectional.center,
      width: (32),
      height: (44),
      decoration: BoxDecoration(
        border: Border.all(color: borderSelect ? color_00131D : color_DADBDC , width: (1) ,),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(text ??'', style: TextStyle(color: color_00131D , fontSize: (18) , fontWeight: FontWeight.w700),),
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
        setState((){
          if(text == "I"){
            print('车牌号中不存在I');
           //车牌号中不存在I
          }else if(text == mABC || text == mProvince){
            isInputABC = !isInputABC;
          }else if(text == mDelete) {
            carNumber = carNumber.substring(0, carNumber.isNotEmpty ? carNumber.length - 1 : 0);
            if(carNumber.isEmpty) isInputABC = false; //自动切换省份or字母逻辑
          }else if(carNumber.length < maxCarNumberLength){
            carNumber += text;
            isInputABC = true; //自动切换省份or字母逻辑
          }

        });
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
