import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.datePublished,
    required this.description,
    required this.webUrl,
  });

  final String imageUrl;
  final String title;
  final String source;
  final String datePublished;
  final String description;
  final String webUrl;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                child: SizedBox(
                  height: height * 0.50,
                  width: width,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: height * 0.45,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.03,
                  ),
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.source,
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.datePublished,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        widget.description,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Link(
                        uri: Uri.parse(widget.webUrl),
                        target: LinkTarget.blank,
                        builder: (BuildContext ctx, FollowLink? openLink) {
                          return TextButton(
                            onPressed: openLink,
                            child: Text(
                              'Read more...',
                              style: GoogleFonts.poppins(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.amberAccent,
                                decorationStyle: TextDecorationStyle.double,
                                decorationThickness: 2,
                                letterSpacing: 3,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
