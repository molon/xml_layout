
import 'dart:typed_data';
import 'dart:ui';

import 'package:xml/xml.dart';

import '../xml_layout.dart';
import 'package:flutter/material.dart';

void reg() {
  XMLLayout.reg(Paint, (node, key) {
    if (node.name == "paint") {
      dynamic v;
      Paint paint = Paint();
      if ((v = node.s<bool>("isAntiAlias")) != null) paint.isAntiAlias = v;
      if ((v = node.s<Color>("color")) != null) paint.color = v;
      if ((v = node.s<BlendMode>("blendMode")) != null) paint.blendMode = v;
      if ((v = node.s<PaintingStyle>("style")) != null) paint.style = v;
      if ((v = node.s<double>("strokeWidth")) != null) paint.strokeWidth = v;
      if ((v = node.s<StrokeCap>("strokeCap")) != null) paint.strokeCap = v;
      if ((v = node.s<StrokeJoin>("strokeJoin")) != null) paint.strokeJoin = v;
      if ((v = node.s<double>("strokeMiterLimit")) != null) paint.strokeMiterLimit = v;
      if ((v = node.s<MaskFilter>("maskFilter")) != null) paint.maskFilter = v;
      if ((v = node.s<FilterQuality>("filterQuality")) != null) paint.filterQuality = v;
      if ((v = node.s<Shader>("shader")) != null) paint.shader = v;
      if ((v = node.s<ColorFilter>("colorFilter")) != null) paint.colorFilter = v;
      if ((v = node.s<ImageFilter>("imageFilter")) != null) paint.imageFilter = v;
      if ((v = node.s<bool>("invertColors")) != null) paint.invertColors = v;
    }
    return null;
  });

  XMLLayout.regEnum(BlendMode.values);
  XMLLayout.regEnum(FilterQuality.values);
  XMLLayout.regEnum(PaintingStyle.values);
  XMLLayout.regEnum(StrokeCap.values);
  XMLLayout.regEnum(StrokeJoin.values);
  XMLLayout.regEnum(BlurStyle.values);
  XMLLayout.reg(MaskFilter, (node, _) {
    String text = node.text;
    Iterable<RegExpMatch> matches = RegExp(r"blur\(([^\)]+)\)").allMatches(text);
    MaskFilter ret;
    if (matches.isNotEmpty) {
      matches.any((element) {
        String text = element.group(1);
        List<String> arr = text.split(',');
        if (arr.length == 2) {
          ret = MaskFilter.blur(NodeData(XmlText(arr[0]), node.state).t<BlurStyle>(), double.parse(arr[1]));
        } else {
          print("$text not match");
        }
        return false;
      });
    } else {
      print("$text not match");
    }
    return ret;
  });
  XMLLayout.reg(ColorFilter, (node, _) {
    List<String> params;
    if ((params = node.splitMethod("mode", 2)) != null) {
      return ColorFilter.mode(node.v<Color>(params[0]), node.v<BlendMode>(params[1]));
    } else if ((params = node.splitMethod("matrix", 16)) != null) {
      return ColorFilter.matrix(params.map<double>((e) => double.parse(e)));
    } else if ((params = node.splitMethod("srgbToLinearGamma", 0)) != null) {
      return ColorFilter.srgbToLinearGamma();
    } else if ((params = node.splitMethod("linearToSrgbGamma", 0)) != null) {
      return ColorFilter.linearToSrgbGamma();
    } else return null;
  });
  XMLLayout.reg(ImageFilter, (node, _) {
    List<String> params;
    if ((params = node.splitMethod("blur", 2)) != null) {
      return ImageFilter.blur(sigmaX: double.parse(params[0]), sigmaY: double.parse(params[1]));
    } else if ((params = node.splitMethod("matrix", 16)) != null) {
      return ImageFilter.matrix(Float64List.fromList(params.map<double>((e)=>double.parse(e))));
    } else return null;
  });
}