import 'package:flutter/material.dart';
import 'package:external_module/external_module.dart';
import 'package:domain/domain.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurantEntity;

  RestaurantCard({@required this.restaurantEntity});

  @override
  Widget build(BuildContext context) {
    CustomScreenUtils.initScreenUtils(context);
    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.5),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: ()
        {},
        child: Row(
          children: [
            Hero(
              tag: restaurantEntity.name,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    restaurantEntity.pictureId,
                    height: 90.w,
                    width: 125.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0.w, 16.w, 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      restaurantEntity.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.darkGrey,
                          fontSize: 16.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pin_drop,
                            color: CustomColors.grey,
                            size: 16.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Text(restaurantEntity.city,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.darkGrey,
                                    fontSize: 14.sp)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Text(restaurantEntity.rating,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.darkGrey,
                                    fontSize: 14.sp)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}