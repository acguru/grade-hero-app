import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/global_functions.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/global_widgets/global_scaffold/global_scaffold.dart';
import 'package:gradeheroapp/global_widgets/save_state_widget.dart';
import 'package:gradeheroapp/routing/generate_routes_blog_page_and_details.dart';
import 'package:gradeheroapp/screens/blog_pages/providers/blog_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/blog_page_body.dart';

class BlogPostsPage extends StatefulWidget {
  const BlogPostsPage({Key? key}) : super(key: key);

  @override
  State<BlogPostsPage> createState() => _BlogPostsPageState();
}

class _BlogPostsPageState extends State<BlogPostsPage> {
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
        label: s.blogScreen_blog,
        hasLeading: false,
        isNavigatingToThisPage: false,
        hasBackLeading: false,
        isCenterTitle: false,
        isScreenScrolling: false,
        isBackIconNavigatingToBack: false,
        hasSearchIcon: true,
        hasBookmarkIcon: true,
        gestureTap: () {
          blogProvider.showMenuNotifier.value = null;
        },
        hasSmartRefresher: true,
        onLeadingTap: () => {
          blogProvider.returnBackToAllList(),
        },
        callFunction: () {
          blogProvider.getAllBlogs(context, isBookMarkedPage: false);
        },
        onRefresh: () {
          blogProvider.getAllBlogs(context, isBookMarkedPage: false);
        },
        onBookmarkTap: () {
          unfocus();
          blogProvider.showMenuNotifier.value = null;
          blogPageAndDetailsNavigatorKey.currentState!.pushNamed(BlogPageAndDetailsNames.BlogBookmarkedPage.toString());
        },
        // todo: think about to add is loading as parameter to
        // todo: stop the close clicking when there is a loading
        onSearchedChange: (value) {
          if (value.toString().isNotEmpty) {
            blogProvider.getSearchedList(context, value);
          } else {
            blogProvider.refreshAllLists();
          }
        },
        child: Consumer<BlogProvider>(
          builder: (context, BlogProvider value, child) {
            return BlogPageBody(
              blogProvider: value,
              scrollController: _scrollController,
              isBookMarkedPage: false,
              blogsList: value.blogsList,
            );
          },
        ),
      ),
    );
  }
}
