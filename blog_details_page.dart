import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/global_widgets/fit_widget.dart';
import 'package:gradeheroapp/global_widgets/get_images.dart';
import 'package:gradeheroapp/global_widgets/global_scaffold/global_scaffold.dart';
import 'package:gradeheroapp/global_widgets/icons_widget.dart';
import 'package:gradeheroapp/global_widgets/share_widgets/share_icons.dart';
import 'package:gradeheroapp/screens/blog_pages/models/blog_model.dart';
import 'package:gradeheroapp/themes/app_colors.dart';
import '../providers/blog_provider.dart';
import 'widgets/blog_post_picture_widget.dart';
import 'widgets/post_title_widget.dart';
import 'widgets/profile_image_date_menu_widget.dart';

class BlogDetailsPage extends StatefulWidget {
  final BlogModel? model;
  final BlogProvider? prov;
  static final ValueNotifier<bool> inBlogPostDetails = ValueNotifier(false);

  const BlogDetailsPage({Key? key, this.model, this.prov}) : super(key: key);

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMethods(context));
  }

  getMethods(context) {
    if (mounted) {
      BlogDetailsPage.inBlogPostDetails.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        blogPageAndDetailsNavigatorKey.currentState?.pop();
        BlogDetailsPage.inBlogPostDetails.value = false;
        return false;
      },
      child: GlobalScaffold(
          hasLeading: true,
          hasBackLeading: true,
          isScreenScrolling: true,
          hasTimerToGetWidget: false,
          isBackIconNavigatingToBack: false,
          onLeadingTap: () => {
                blogPageAndDetailsNavigatorKey.currentState?.pop(),
                BlogDetailsPage.inBlogPostDetails.value = false
              },
          actionWidget: Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: getSize(21.78)),
                child: FitWidget(
                  width: 21,
                  height: 21,
                  onTap: () => showShareModalBottomSheet(
                      text: widget.model!.getContentToShare,
                      imagePath: widget.model!.getPicture),
                  child: GetImages(
                    image: AppImages.shareBlog,
                    scale: 4,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: getSize(0)),
                child: FitWidget(
                  width: 21,
                  height: 21,
                  onTap: () async => {
                    await widget.prov!.bookMarkAPost(widget.model!, isBookMarkedPage: false),
                    setState(() {})
                  },
                  child: IconsWidget(
                    icon: widget.model != null && widget.model!.getIsBookMarked
                        ? AppIcons.filledBookmark
                        : AppIcons.outlinedBookmark,
                    color: widget.model != null && widget.model!.getIsBookMarked
                        ? AppColors.greenColor
                        : AppColors.primaryColor,
                  ),
                ),
              )
            ],
          ),
          child: Center(
            child: Container(
              width: getSize(335),
              padding: EdgeInsets.only(bottom: getSizeWrtHeight(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1st row
                  Hero(
                    tag: 'blogDetails${widget.model!.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// image - date - menu
                          ProfileImageDateMenuWidget(
                              model: widget.model, hasMenu: false),

                          /// post title widget
                          PostTitleWidget(model: widget.model),

                          /// image widget
                          BlogPostPictureWidget(model: widget.model),
                        ],
                      ),
                    ),
                  ),

                  /// post description
                  Padding(
                    padding: EdgeInsets.only(top: getSizeWrtHeight(5)),
                    child: Html(
                      data: widget.model!.getContent!,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
