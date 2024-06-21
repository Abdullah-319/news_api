import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_api/widgets/categories_list_view.dart';
import 'package:news_api/widgets/category_news_list_view.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
    // final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;

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
      body: Column(
        children: [
          CategoriesListView(categoriesList: categoriesList),
          CategoryNewsListView(category: category),
        ],
      ),
    );
  }
}
