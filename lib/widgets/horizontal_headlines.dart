import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api/models/news_channel_headlines_model.dart';
import 'package:news_api/view/news_detail_screen.dart';
import 'package:news_api/view_model/news_view_model.dart';
import 'package:http/http.dart' as http;

class HorizontalHeadlines extends StatelessWidget {
  const HorizontalHeadlines({super.key, required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    final format = DateFormat('MMMM dd, yyyy');

    NewsViewModel newsViewModel = NewsViewModel();

    Future<bool> checkImageExists(String uri) async {
      try {
        final response = await http.get(Uri.parse(uri));
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print('Error: $e');
        return false;
      }
    }



    return SizedBox(
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
          } else if (snapshot.data!.articles!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text(
                    "Couldn't load news at the time",
                    style: GoogleFonts.poppins(fontSize: width * 0.09),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.articles!.length,
              itemBuilder: (context, index) {
                final dateTime = DateTime.parse(
                    snapshot.data!.articles![index].publishedAt.toString());
    
                return GestureDetector(
                  onTap: () {
                    print(snapshot.data!.articles![index].urlToImage
                        .toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  title: snapshot.data!.articles![index].title
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
                  child: snapshot.data!.articles![index].title.toString() ==
                              "[Removed]" ||
                          snapshot.data!.articles![index].urlToImage
                                  .toString() ==
                              "null" ||
                          checkImageExists(snapshot
                                  .data!.articles![index].urlToImage
                                  .toString()) ==
                              true
                      ? Container()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02,
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
                                color: Colors.grey.shade300,
                                elevation: 10,
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
    );
  }
}
