import 'package:car_number_view/car_number/carnumber_overlay.dart';
import 'package:car_number_view/car_number/carnumber_keyboard.dart';
import 'package:flutter/material.dart';

import 'car_number/add_carnumber_page.dart';
import 'car_number/carnumber_bottom_dialog.dart';
import 'utils/color_res.dart';
import 'utils/screen_utils.dart';

void main() => runApp(const MyApp());

ValueNotifier<String> mCarNumber = ValueNotifier('');


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_00131D,
      body: Column(
        children: [
          SizedBox(height: 20,),

          ValueListenableBuilder<String>(
            valueListenable: mCarNumber,
            builder: (BuildContext context, value, Widget? child) {
              return
              ButtonView(() {
              }, '当前号码： $value');
            },
          ),


          ButtonView(() {
            openCarNumberViewDialog(context, mCarNumber.value);
          }, "底部弹框-车牌号"),

          ButtonView(() {
            openCarNumberKeyboardRoute(context, mCarNumber.value , (n , t){
              mCarNumber.value = n;
              if(t == "完成"){
                Navigator.pop(context);
              }
            });
          }, "键盘弹框页面"),

          ButtonView(() {
            openAddCarNumberRoute(context , mCarNumber.value);
          }, "新页面添加车牌号"),

          ButtonView(() {
            CarNumberViewOverlay.getInstance().showKeyboard(context, (carNumber, value) {
              mCarNumber.value = carNumber;
              if(value == "完成"){
                CarNumberViewOverlay.getInstance().hideKeyboard();
              }
            });
          }, "悬浮框键盘"),
        ],
      ),
    );
  }

  Widget ButtonView(GestureTapCallback? tap,String? t){
    return InkWell(
      onTap: tap,
      child: Container(
        alignment: AlignmentDirectional.center,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        height: 40,
        width: ScreenUtils.getScreenWidth(context),
        decoration: BoxDecoration(
            color: color_fff,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Text(
          t??"-",
        ),
      ),
    );
  }
}
