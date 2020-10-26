import 'package:flutter/material.dart';
import 'package:external_module/external_module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final String errorImage;

  CustomErrorWidget({
    @required this.errorMessage,
    @required this.errorImage,
  });

  @override
  Widget build(BuildContext context) {
    CustomScreenUtils.initScreenUtils(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          errorImage,
          width: 150.w,
          height: 150.w,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.w, left: 32.w, right: 32.w),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomColors.yellow,
                fontSize: 20.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
