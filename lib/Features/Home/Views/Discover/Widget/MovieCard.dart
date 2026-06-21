import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Features/Home/Views/Discover/Controller/discover_controller.dart';
import '../Models/discrive_models.dart';

class MovieCard extends StatelessWidget {
  final DiscoverMovie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<DiscoverController>().playContentDirectly(movie.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: movie.image.startsWith('http')
                    ? Image.network(
                        movie.image,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150.h,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        ),
                      )
                    : (movie.image.isEmpty
                        ? Container(
                            height: 150.h,
                            width: double.infinity,
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image, color: Colors.white54),
                          )
                        : Image.asset(
                            movie.image,
                            height: 150.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )),
              ),
              if (movie.badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76212),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: CustomText(
                      text: movie.badge!,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                bottom: 6.h,
                right: 6.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 16.sp),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: movie.views,
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: movie.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: movie.subtitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
