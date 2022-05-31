import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/global_functions.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/global_widgets/fit_widget.dart';
import 'package:gradeheroapp/global_widgets/get_images.dart';
import 'package:gradeheroapp/global_widgets/global_scaffold/global_scaffold.dart';
import 'package:gradeheroapp/global_widgets/icons_widget.dart';
import 'package:gradeheroapp/global_widgets/loading_widget.dart';
import 'package:gradeheroapp/global_widgets/share_widgets/share_icons.dart';
import 'package:gradeheroapp/routing/generate_routes_blog_page_and_details.dart';
import 'package:gradeheroapp/screens/blog_pages/models/blog_model.dart';
import 'package:gradeheroapp/screens/blog_pages/providers/blog_provider.dart';
import 'package:gradeheroapp/themes/app_colors.dart';
import 'package:gradeheroapp/themes/global_designs.dart';
import 'blog_post_picture_widget.dart';
import 'post_title_widget.dart';
import 'profile_image_date_menu_widget.dart';

class BlogPageBody extends StatelessWidget {
  const BlogPageBody(
      {Key? key,
      this.blogProvider,
      this.scrollController,
      this.isBookMarkedPage = false,
      this.blogsList})
      : super(key: key);

  final BlogProvider? blogProvider;
  final ScrollController? scrollController;
  final bool? isBookMarkedPage;
  final List<BlogModel>? blogsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: width,
      child: Padding(
        padding: EdgeInsets.only(top: getSizeWrtHeight(41)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: blogsList!.length,
              itemBuilder: (context, index) {
                return BlogPostWidget(
                  model: blogsList![index],
                  prov: blogProvider,
                  isBookMarkedPage: isBookMarkedPage!,
                );
              },
            ),
            if (blogProvider!.searchedValue != null && blogProvider!.searchedValue?.isNotEmpty != null && blogProvider!.getIsLoading)
              Container(
                color: Colors.transparent,
                width: width,
                height: width,
                child: LoadingWidget(
                  width: getSize(40),
                  height: getSize(40),
                  isLoading: true,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class BlogPostWidget extends StatelessWidget {
  final BlogModel? model;
  final BlogProvider? prov;
  final bool isBookMarkedPage;

  const BlogPostWidget({Key? key, this.model, this.prov, this.isBookMarkedPage = false}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getSize(335),
      height: getSizeWrtHeight(49 + 12 + 153 + 13 + 20 + 46 + 18),
      padding: EdgeInsets.only(bottom: getSizeWrtHeight(18)),
      child: GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// 1st row - image - title - menu - and image
                  Container(
                    height: getSizeWrtHeight(49 + 12 + 153),
                    child: Hero(
                      tag: 'blogDetails${model!.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            /// image - date - menu
                            Container(
                                width: getSize(335 + 40),
                                child: Center(
                                  child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: getSize(20)),
                                  child: ProfileImageDateMenuWidget(
                                      model: model,
                                      onTap: () {
                                        unfocus();
                                        if (prov!.showMenuNotifier.value != model!.id) {
                                          prov!.showMenuNotifier.value = model!.id;
                                        } else
                                          prov!.showMenuNotifier.value = null;
                                      }),
                                ))),

                            /// image widget
                            Container(
                              width: getSize(335),
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(end: getSizeWrtHeight(0)),
                                child: GestureDetector(
                                    onTap: () => {
                                          unfocus(),
                                          GlobalScaffold.searchNotifier.value = false,
                                          prov!.showMenuNotifier.value = null,
                                          blogPageAndDetailsNavigatorKey.currentState!
                                          .pushNamed(BlogPageAndDetailsNames.BlogDetailsPage.toString(),
                                              arguments: {
                                                "model": model,
                                                "prov": prov
                                              })
                                        },
                                    child: BlogPostPictureWidget(model: model)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// post description
                  SizedBox(
                    width: getSize(335),
                    child: GestureDetector(
                      onTap: () => {
                        GlobalScaffold.searchNotifier.value = false,
                        unfocus(),
                        prov!.showMenuNotifier.value = null,
                        blogPageAndDetailsNavigatorKey.currentState!.pushNamed(
                            BlogPageAndDetailsNames.BlogDetailsPage.toString(),
                            arguments: {"model": model, "prov": prov}),
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: getSizeWrtHeight(0)),
                        child: Container(
                          width: getSize(335),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// post title widget
                              PostTitleWidget(model: model),

                              /// post brief description
                              Padding(
                                padding:EdgeInsets.only(top: getSizeWrtHeight(5)),
                                child: Text(
                                  model!.getPostBriefDescription!,
                                  style: appFont.regular12LightGrayColorHeightFontStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Align(
                alignment: AlignmentDirectional.topEnd,
                child: ValueListenableBuilder(
                  valueListenable: prov!.showMenuNotifier,
                  builder: (context, String? value, _) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(top: getSizeWrtHeight(40), end: getSize(20)),
                      child: MenuWidget(
                        value: value == model!.id,
                        model: model,
                        onTap: (String title) {
                          /// book mark function
                          if (title == 'Bookmark') {
                            prov!.bookMarkAPost(model!,isBookMarkedPage: isBookMarkedPage);
                          }

                          /// share function
                          else
                            showShareModalBottomSheet(
                                text: model!.getContentToShare,
                                imagePath: model!.getPicture);

                          prov!.showMenuNotifier.value = null;

                        },
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

final List list = [
    {'icon': AppIcons.filledBookmark, 'title': 'Bookmark'},
    {'icon': AppImages.shareBlog, 'title': 'Share'},
];

class MenuWidget extends StatelessWidget {
  MenuWidget({Key? key, required this.value, this.model, this.onTap}): super(key: key);

  final bool value;
  final BlogModel? model;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      width: value ? getSize(155) : 0,
      height: value ? getSizeWrtHeight(103.59) : 0,
      curve: Curves.ease,
      child: FitWidget(
        width: value ? 155 : 0,
        height: value ? 103.59 : 0,
        child: Container(
          width: getSize(155),
          height: getSizeWrtHeight(103.59),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: getBoxShadow(yOffset: 1, blurRadius: 20)),
          child: Padding(
            padding: EdgeInsets.only(top: getSizeWrtHeight(18.59)),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: getSizeWrtHeight(24)),
                  child: GestureDetector(
                    onTap: () => onTap!(list[index]['title']),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          /// icon
                          Container(
                            width: getSize(48),
                            child: Center(
                              child: list[index]['icon'] == AppImages.shareBlog? 
                              FitWidget(
                                      width: 21,
                                      height: 21,
                                      child: GetImages(
                                        image: list[index]['icon'],
                                      ),
                                    )
                                  : FitWidget(
                                      width: 21,
                                      height: 21,
                                      child: IconsWidget(
                                        icon: model != null && model!.getIsBookMarked
                                            ? AppIcons.filledBookmark
                                            : AppIcons.outlinedBookmark,
                                        color: model != null && model!.getIsBookMarked
                                            ? AppColors.greenColor
                                            : AppColors.primaryColor,
                                      ),
                                    ),
                            ),
                          ),

                          /// title
                          Text(list[index]['title'], style:appFont.regular15DarkPrimaryColorFontStyle),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
