import 'package:flutter/material.dart';
import 'package:gradeheroapp/global_widgets/cashed_image_network_widget.dart';
import 'package:gradeheroapp/screens/blog_pages/models/blog_model.dart';
import 'package:gradeheroapp/themes/app_colors.dart';
import 'package:gradeheroapp/themes/get_page_proportions.dart';

class BlogPostPictureWidget extends StatelessWidget {
  const BlogPostPictureWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final BlogModel? model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getSizeWrtHeight(12)),
      child: Container(
        width: getSize(335),
        height: getSizeWrtHeight(153),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.moreLightGrayColor),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CashedNetworkImageWidget(
            path: model!.getPicture,
            borderRadius: 8,
            isCircledImage: false,
            hasMainIconAsDefault: true,
            width: getSize(335),
            height: getSizeWrtHeight(153),
          ),
        ),
      ),
    );
  }
}
