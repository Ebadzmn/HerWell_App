import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Model/standart_vip_model.dart';

class SubscribeCard extends StatelessWidget {
  final VipPlanModel plan;

  const SubscribeCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF151514), // dark brown-black (বেশিরভাগ অংশ)
                Color(0xFF3D2010),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.badge != null) SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.vip_icon,
                        width: 28.w,
                        height: 28.w,
                      ),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: plan.title,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF0F0F0),
                      ),
                    ],
                  ),
                  CustomText(
                    text: "\$${plan.price}",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFD400),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomText(
                text: "Auto -renew. Cancel anytime.",
                fontSize: 12.sp,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 22.h),
              Column(
                children: [
                  // Row 1
                  Row(
                    children: [
                      Expanded(child: _buildFeatureItem(plan.features[0])),
                      SizedBox(width: 10.w),
                      Expanded(child: _buildFeatureItem(plan.features[1])),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Row 2
                  Row(
                    children: [
                      Expanded(child: _buildFeatureItem(plan.features[2])),
                      SizedBox(width: 10.w),
                      Expanded(child: _buildFeatureItem(plan.features[3])),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (plan.badge != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF2424), // Vibrant red
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: CustomText(
                text: plan.badge!,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureItem(VipFeatureModel feature) {
    return Row(
      children: [
        SvgPicture.asset(feature.iconPath, width: 24.w, height: 24.w),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomText(
            text: feature.label,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFFF8F7F5),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class MovieGrid extends StatelessWidget {
  final List<MovieModel> movies;
  final String title;

  const MovieGrid({super.key, required this.movies, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        SizedBox(height: 18.h),
        SizedBox(
          height:
              260.h, // Fixed height to accommodate content and prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                width: 110.w,
                margin: EdgeInsets.only(right: 12.w),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              movie.image,
                              height: 150.h,
                              width: 110.w,
                              fit: BoxFit.cover,
                            ),
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
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.r),
                                    bottomLeft: Radius.circular(8.r),
                                  ),
                                ),
                                child: CustomText(
                                  text: movie.badge!,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 4.h,
                            right: 4.w,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                                CustomText(
                                  text: movie.views,
                                  fontSize: 8.sp,
                                  color: Colors.white,
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
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFE3E3E3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomText(
                        text: movie.subtitle,
                        fontSize: 12.sp,
                        color: Color(0xFFCFCDCD),
                        fontWeight: FontWeight.w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SubscriptionRules extends StatelessWidget {
  final List<String> rules;
  const SubscriptionRules({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "About Subscription",
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFFFFFFF),
        ),
        SizedBox(height: 12.h),
        ...rules.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "${entry.key + 1}. ",
                  fontSize: 12.sp,
                  color: const Color(0xFFCFCDCD),
                ),
                Expanded(
                  child: CustomText(
                    text: entry.value,
                    fontSize: 12.sp,
                    color: const Color(0xFFCFCDCD),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
