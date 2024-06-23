import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_api/view/categories_screen.dart';
import 'package:news_api/widgets/horizontal_headlines.dart';
import 'package:news_api/widgets/vertical_headlines.dart';

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
  FiltersList? selectedMenu;
  String source = "bbc-news";
  String category = "General";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Headlines",
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
                source = "cbc-news";
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
                  "CBC-News",
                ),
              ),
            ],
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: height * 0.5,
                child: HorizontalHeadlines(source: source),
              ),
            ),
          ];
        },
        body: VerticalHeadlines(category: category),
      ),
    );
  }
}
