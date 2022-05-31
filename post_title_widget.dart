import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/screens/blog_pages/models/blog_model.dart';

class PostTitleWidget extends StatelessWidget {
  const PostTitleWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final BlogModel? model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getSizeWrtHeight(13)),
      child: Text(
        model!.getPostTitle!,
        style: appFont.medium14DarkPrimaryColorFontStyle,
      ),
    );
  }
}