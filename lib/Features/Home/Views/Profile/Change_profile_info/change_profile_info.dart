import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_images.dart';
import 'Controller/change_profile_info_controller.dart';

class ChangeProfileInfoScreen extends StatefulWidget {
  const ChangeProfileInfoScreen({super.key});

  @override
  State<ChangeProfileInfoScreen> createState() =>
      _ChangeProfileInfoScreenState();
}

class _ChangeProfileInfoScreenState extends State<ChangeProfileInfoScreen> {
  final controller = Get.put(ChangeProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black100,
      appBar: const CustomAppBar(
        title: "Change Profile Information",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            // Profile Image Edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundImage: AssetImage(AppImages.profile_image),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.white100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.orange100,
                          width: 1.w,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.orange100,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Name Field
            _buildLabel("Name"),
            SizedBox(height: 8.h),
            Customtextfield(
              controller: controller.nameController.value,
              hintText: "Enter your Full Name",
              obscureText: false,
              textInputType: TextInputType.name,
            ),
            SizedBox(height: 16.h),



            // Gender Selector
            _buildLabel("Select Gender"),
            SizedBox(height: 8.h),
            Obx(() => _buildGenderDropdown()),
            SizedBox(height: 16.h),

            // Date of Birth
            _buildLabel("Date of Birth"),
            SizedBox(height: 8.h),
            Obx(() => _buildDatePicker(context)),

            SizedBox(height: 84.h),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!controller.isLoading.value) {
                    controller.updateProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          height: 20.sp,
                          width: 20.sp,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : CustomText(
                          text: "Save",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  backgroundColor: AppColors.gray100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                child: CustomText(
                  text: "Cancel",
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CustomText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w400);
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: CustomText(
          text: controller.selectedGender.value,
          fontSize: 14.sp,
          color: AppColors.black100,
          fontWeight: FontWeight.w400,
        ),
        items: controller.genderList
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: CustomText(
                  text: item,
                  fontSize: 14.sp,
                  color: AppColors.black100,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
            .toList(),
        value: controller.selectedGender.value,
        onChanged: (String? value) {
          controller.updateGender(value);
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.gray200,
            size: 24.sp,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Color(0xFFEFF6FF),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => controller.chooseDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: controller.selectedDate.value,
              fontSize: 14.sp,
              color: controller.selectedDate.value == "DD.MM.YY"
                  ? AppColors.gray200
                  : AppColors.black100,
              fontWeight: FontWeight.w400,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.gray200,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
