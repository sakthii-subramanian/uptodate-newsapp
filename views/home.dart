// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';

class HomePage extends StatefulWidget {
  bool isDarkMode;
  HomePage({required this.isDarkMode});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode == true ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            widget.isDarkMode == true ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          "UPTODATE",
          style: TextStyle(
            color:
                widget.isDarkMode == true ? Colors.greenAccent : Colors.black,
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (widget.isDarkMode == true) {
                  widget.isDarkMode = false;
                } else {
                  widget.isDarkMode = true;
                }
              });
            },
            icon: Icon(
              widget.isDarkMode == true
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color:
                  widget.isDarkMode == true ? Colors.greenAccent : Colors.black,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Categories
                  Container(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          imageUrl: categories[index].imageUrl,
                          categoryName: categories[index].categoryName,
                          isDMode: widget.isDarkMode,
                        );
                      },
                    ),
                  ),

                  // News Cards
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(top: 18),
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            title: articles[index].title,
                            imageUrl: articles[index].urlToimage,
                            desc: articles[index].description,
                            webViewUrl: articles[index].url,
                            isDMode: widget.isDarkMode,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String categoryName;
  final bool isDMode;
  CategoryTile({
    required this.imageUrl,
    required this.categoryName,
    required this.isDMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) {
              return CategoryNews(
                category: categoryName.toLowerCase(),
                isDModeCategory: isDMode,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              width: 120,
              height: 80,
              child: Text(
                categoryName,
                style: TextStyle(
                  color: isDMode == true ? Colors.greenAccent : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String title, imageUrl, desc, webViewUrl;
  final bool isDMode;
  BlogTile({
    required this.title,
    required this.imageUrl,
    required this.desc,
    required this.webViewUrl,
    required this.isDMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) {
              return ArticleView(
                webUrl: webViewUrl,
                isDModeArticle: isDMode,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl),
            ),
            Text(
              title,
              style: TextStyle(
                color: isDMode == true ? Colors.greenAccent : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(
                color: isDMode == true
                    ? Color.fromARGB(255, 109, 131, 120)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
