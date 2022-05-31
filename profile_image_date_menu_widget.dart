import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/global_widgets/cashed_image_network_widget.dart';
import 'package:gradeheroapp/screens/blog_pages/models/blog_model.dart';
import 'package:gradeheroapp/themes/app_colors.dart';

class ProfileImageDateMenuWidget extends StatelessWidget {
  const ProfileImageDateMenuWidget({
    Key? key,
    required this.model,
    this.hasMenu = true,
    this.onTap,
  }) : super(key: key);

  final BlogModel? model;
  final bool? hasMenu;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// at start position
        Row(
          children: [
            /// image widget -- has conditions according to types
            CashedNetworkImageWidget(
              path: model!.getProfilePicture,
              width: getSizeWrtHeight(49),
            ),

            /// title and subtitle widgets -- same for all types
            Padding(
              padding: EdgeInsetsDirectional.only(start: getSize(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// title widget
                  Text(
                    model!.getTitle!,
                    style: appFont.medium13DarkPrimaryFontStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  spacer9Widget,

                  /// subtitle widget
                  Text(
                    model!.getCreatedAtDateFormatted,
                    style: appFont.regular10LightGrayFontStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),

        /// menu - at end position -- has conditions according to types
        if (hasMenu!) getMenu()
      ],
    );
  }

Widget getBox()=> Container(
                        width: getSize(3),
                        height: getSize(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.lightGrayColor));

Widget getMenu() => Padding(
            padding: EdgeInsetsDirectional.only(end: getSize(10)),
            child: GestureDetector(
              onTap: () => onTap!(),
              child: Container(
                width: getSize(24),
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 4, getSize(10), 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      getBox(),  
                      spacer4Widget,
                      getBox(),  
                      spacer4Widget,
                      getBox(),                     
                    ],
                  ),
                ),
              ),
            ),
          );
}