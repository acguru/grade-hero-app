import 'package:flutter/material.dart';
import 'package:gradeheroapp/config_service/globals.dart';
import 'package:gradeheroapp/routing/generate_routes_blog_page_and_details.dart';

class MainBlogPage extends StatelessWidget {
  const MainBlogPage({Key? key}) : super(key: key);

  void pop(){
    if (blogPageAndDetailsNavigatorKey.currentState!.canPop()) {
      blogPageAndDetailsNavigatorKey.currentState!.pop();
    } 
  }

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(onWillPop: () async{
    if (blogPageAndDetailsNavigatorKey.currentState!.canPop()) {
      blogPageAndDetailsNavigatorKey.currentState!.pop();
    } 
    return false;
    },
    child:
    MaterialApp(
      navigatorKey: blogPageAndDetailsNavigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: BlogPageAndDetailsNames.BlogPostsPage.toString(),
      onGenerateRoute: blogPageAndDetailsRouteGenerator.generatorRoute,
    ));
  }
}
