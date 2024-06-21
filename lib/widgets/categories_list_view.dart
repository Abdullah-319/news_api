import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key, required this.categoriesList});

  final List<String> categoriesList;

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    String category = "General";

    return SizedBox(
      height: height * 0.07,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categoriesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                left: width * 0.05,
                bottom: height * 0.0075,
                top: height * 0.0075),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    category = widget.categoriesList[index];
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.01,
                    horizontal: width * 0.05,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.categoriesList[index] == category
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text(
                    widget.categoriesList[index],
                    style: GoogleFonts.poppins(
                      color: widget.categoriesList[index] == category
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
    );
  }
}
