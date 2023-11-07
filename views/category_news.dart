// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/views/article_view.dart';
import '../helper/news.dart';

class CategoryNews extends StatefulWidget {
  CategoryNews({required this.category,required this.isDModeCategory,});
  final String category;
  final bool isDModeCategory;

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  bool isLoading = true;

  List<ArticleModel> articles = <ArticleModel>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getCategoryNews(widget.category);
    articles = newsClass.news;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDModeCategory == true ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_sharp,
            color: widget.isDModeCategory == true ? Colors.greenAccent : Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: widget.isDModeCategory == true ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          "UPTODATE",
          style: TextStyle(
            color: widget.isDModeCategory == true ? Colors.greenAccent : Colors.black,
            fontSize: 35,
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
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
                            isDMode: widget.isDModeCategory,
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

class BlogTile extends StatelessWidget {
  final String title, imageUrl, desc, webViewUrl;
  final bool isDMode;
  BlogTile(
      {required this.title,
      required this.imageUrl,
      required this.desc,
      required this.webViewUrl,
      required this.isDMode,});

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
                color:isDMode == true
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
