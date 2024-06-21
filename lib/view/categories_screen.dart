import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api/models/category_news_model.dart';
import 'package:news_api/view_model/news_detail_screen.dart';
import 'package:news_api/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');

  String category = "General";

  List<String> categoriesList = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology",
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Categories",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: SizedBox(
                height: height * 0.055,
                width: width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              category = categoriesList[index];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                              horizontal: width * 0.05,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: categoriesList[index] == category
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            child: Text(
                              categoriesList[index],
                              style: GoogleFonts.poppins(
                                color: categoriesList[index] == category
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
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

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        title: snapshot
                                            .data!.articles![index].title
                                            .toString(),
                                        source: snapshot
                                            .data!.articles![index].source!.name
                                            .toString(),
                                        datePublished:
                                            format.format(dateTime).toString(),
                                        description: snapshot
                                            .data!.articles![index].description
                                            .toString())));
                          },
                          child: snapshot.data!.articles![index].title
                                          .toString() ==
                                      "[Removed]" ||
                                  snapshot.data!.articles![index].urlToImage
                                          .toString() ==
                                      "null"
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.015,
                                  ),
                                  height: height * 0.25,
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox(
                                          height: height,
                                          width: width * 0.35,
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return SpinKitFadingCircle(
                                                color: Colors.amber,
                                                size: height * 0.08,
                                              );
                                            },
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.03),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      format.format(dateTime),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
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
      ),
    );
  }
}
