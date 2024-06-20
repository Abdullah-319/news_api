import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api/models/category_news_model.dart';
import 'package:news_api/models/news_channel_headlines_model.dart';
import 'package:news_api/view/categories_screen.dart';
import 'package:news_api/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FiltersList {
  bbcNews,
  aryNews,
  independent,
  cnn,
  alJazeera,
  bbcSport,
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');

  FiltersList? selectedMenu;
  String source = "bbc-news";
  String category = "General";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Headline News",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            filterQuality: FilterQuality.high,
            height: 18,
            width: 18,
          ),
        ),
        actions: [
          PopupMenuButton<FiltersList>(
            initialValue: selectedMenu,
            onSelected: (FiltersList menu) {
              if (FiltersList.bbcNews.name == menu.name) {
                source = "bbc-news";
              }
              if (FiltersList.aryNews.name == menu.name) {
                source = "ary-news";
              }
              if (FiltersList.cnn.name == menu.name) {
                source = "cnn-news";
              }
              if (FiltersList.alJazeera.name == menu.name) {
                source = "al-jazeera-english";
              }
              if (FiltersList.independent.name == menu.name) {
                source = "abc-news";
              }
              if (FiltersList.bbcSport.name == menu.name) {
                source = "bbc-sport";
              }
              setState(() {});
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => <PopupMenuEntry<FiltersList>>[
              const PopupMenuItem(
                value: FiltersList.bbcNews,
                child: Text(
                  "BBC-News",
                ),
              ),
              const PopupMenuItem(
                value: FiltersList.bbcSport,
                child: Text(
                  "BBC-Sport",
                ),
              ),
              const PopupMenuItem(
                value: FiltersList.aryNews,
                child: Text(
                  "Ary-News",
                ),
              ),
              const PopupMenuItem(
                value: FiltersList.alJazeera,
                child: Text(
                  "AlJazeera-News",
                ),
              ),
              const PopupMenuItem(
                value: FiltersList.independent,
                child: Text(
                  "Independent-News",
                ),
              ),
              const PopupMenuItem(
                value: FiltersList.cnn,
                child: Text(
                  "CNN-News",
                ),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewsHeadlinesApi(source),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: height * 0.08,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      return Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: height * 0.02,
                              ),
                              height: height,
                              width: width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return SpinKitFadingCircle(
                                      color: Colors.amber,
                                      size: height * 0.08,
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                color: Colors.grey.shade100,
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 10,
                                  ),
                                  height: height * 0.22,
                                  width: width * 0.75,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: height * 0.01),
            width: width,
            height: height,
            child: FutureBuilder<CategoryNewsModel>(
              future: newsViewModel.fetchCategoryNewsApi(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: height * 0.08,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.015,
                        ),
                        height: height * 0.25,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: height,
                                width: width * 0.35,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return SpinKitFadingCircle(
                                      color: Colors.amber,
                                      size: height * 0.08,
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.03),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
