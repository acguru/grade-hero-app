import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/global_widgets/global_scaffold/global_scaffold.dart';
import 'package:gradeheroapp/global_widgets/save_state_widget.dart';
import 'package:gradeheroapp/screens/blog_pages/providers/blog_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/blog_page_body.dart';

class BlogBookmarkedPage extends StatefulWidget {
  static final ValueNotifier<bool> inBlogBookMarkedPage = ValueNotifier(false);

  const BlogBookmarkedPage({Key? key}): super(key: key);

  @override
  State<BlogBookmarkedPage> createState() => _BlogBookmarkedPageState();
}

class _BlogBookmarkedPageState extends State<BlogBookmarkedPage> {
  late ScrollController _scrollController;
  late BlogProvider blogProvider;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMethods(context));
    _scrollController.addListener(() {
      blogProvider.showMenuNotifier.value = null;
    });
  }

  getMethods(context) async {
    try {
      BlogBookmarkedPage.inBlogBookMarkedPage.value = true;
      blogProvider.clearBlogsList();
    } catch (e) {
      print('eee $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    blogProvider = Provider.of<BlogProvider>(context, listen: false);
    return SaveStateWidget(
      child: GlobalScaffold(
        label: s.blogScreen_bookmarkedBlogs,
        hasLeading: true,
        isNavigatingToThisPage: false,
        hasBackLeading: true,
        isCenterTitle: true,
        isScreenScrolling: false,
        isBackIconNavigatingToBack: false,
        hasSearchIcon: false,
        hasBookmarkIcon: false,
        hasSmartRefresher: true,
        onLeadingTap: () => {
          blogPageAndDetailsNavigatorKey.currentState?.pop(),
          BlogBookmarkedPage.inBlogBookMarkedPage.value = false,
        },
        callFunction: () {
          blogProvider.getAllBlogs(context,isBookMarkedPage: true);
        },
        onRefresh: () {
          blogProvider.getAllBlogs(context,isBookMarkedPage: true);
        },
        child: Consumer<BlogProvider>(
          builder: (context, BlogProvider value, child) {
            return BlogPageBody(
              blogProvider: value,
              scrollController: _scrollController,
              isBookMarkedPage: true,
              blogsList: value.bookMarkedList,
            );
          },
        ),
      ),
    );
  }
}
