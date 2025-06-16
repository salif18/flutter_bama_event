import 'package:bama/models/categorie_model.dart';
import 'package:bama/screens/categories/categorie.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildCategoriList extends StatelessWidget {
  const BuildCategoriList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 50.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: CategorieModel.getCategorie().length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final category = CategorieModel.getCategorie()[index];
              return InkWell(
                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Category(categorie:category.title))),
                child: AspectRatio(
                  aspectRatio: 2.2 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      // ignore: deprecated_member_use
                      color: ColorApp.backgroundCard,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              // color: category.color,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: category.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
