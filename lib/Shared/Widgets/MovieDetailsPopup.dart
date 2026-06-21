import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Features/Home/Views/Discover/Models/discrive_models.dart';
import 'Custom_Text.dart';

class MovieDetailsPopup extends StatelessWidget {
  final DiscoverMovie movie;
  final VoidCallback onClose;

  const MovieDetailsPopup({
    super.key,
    required this.movie,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withOpacity(0.8),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 310.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Image Area
                      Stack(
                        children: [
                          ClipRRect(
                            child: movie.image.isEmpty
                                ? Container(
                                    height: 420.h,
                                    width: double.infinity,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                                  )
                                : (movie.image.startsWith('http')
                                    ? Image.network(
                                        movie.image,
                                        height: 420.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 420.h,
                                          width: double.infinity,
                                          color: Colors.grey[800],
                                          child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                                        ),
                                      )
                                    : Image.asset(
                                        movie.image,
                                        height: 420.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          // Gradient overlay from bottom of image
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 180.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF131313).withOpacity(0.9),
                                    const Color(0xFF131313),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Content on top of image gradient
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 20.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: '"${movie.title}"',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFFFFFF),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12.h),
                                  // Category Tags
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildTag("Surrogate Bride"),
                                      SizedBox(width: 8.w),
                                      _buildTag("Taboo"),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  // Play Button
                                  GestureDetector(
                                    onTap: () {
                                      onClose();
                                      Get.toNamed(
                                        Routes.shortsFullSeriesOverlay,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE50914),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ), // Sharper corners like picture
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: "Play",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Close Button (Top Right)
                Positioned(
                  top: -45.h, // Halfway outside
                  right: -12.w, // Halfway outside
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.white, width: 1.w),
      ),
      child: CustomText(
        text: text,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: Color(0xFFDBDBDB),
      ),
    );
  }
}
