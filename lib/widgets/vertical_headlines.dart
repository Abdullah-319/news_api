import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api/models/category_news_model.dart';
import 'package:news_api/view/news_detail_screen.dart';
import 'package:news_api/view_model/news_view_model.dart';

class VerticalHeadlines extends StatelessWidget {
  const VerticalHeadlines({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    final format = DateFormat('MMMM dd, yyyy');

    NewsViewModel newsViewModel = NewsViewModel();

    return Container(
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
                                          .toString(),
                                  webUrl: snapshot.data!.articles![index].url
                                      .toString(),
                                )));
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
                                        padding:
                                            EdgeInsets.only(left: width * 0.03),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!.articles![index].title
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
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
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
          );
  }
}