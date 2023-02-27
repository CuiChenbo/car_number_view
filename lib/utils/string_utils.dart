import 'package:flutter/material.dart';

class StringUtils {
  static List<String> stringToStringList(String text){
    List<String> list = [];
    for(int i = 0; i < text.length ; i++){
      list.add(text.substring(i,i+1));
    }
    return list;
  }

  static String stringListToString(List<String> list){
    var text = '';
    for(int i = 0; i < list.length ; i++){
      text+=list[i];
    }
    return text;
  }


}