import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modularization/common/custom_colors.dart';
import 'package:flutter_modularization/common/custom_screen_utils.dart';
import 'package:flutter_modularization/common/image_strings.dart';
import 'package:flutter_modularization/network/api_constant.dart';
import 'package:flutter_modularization/network/get_list_restaurant_use_case.dart';
import 'package:flutter_modularization/network/remote_data_source.dart';
import 'package:flutter_modularization/network/restaurant_repository.dart';
import 'package:flutter_modularization/ui/restaurant_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_error_widget.dart';
import 'custom_loading_progress.dart';
import 'get_list_restaurant_bloc.dart';
import 'get_list_restaurant_event.dart';
import 'get_list_restaurant_state.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CustomScreenUtils.initScreenUtils(context);
    return BlocProvider(
      create: (context) => GetListRestaurantBloc(
        getListRestaurantUseCase: GetListRestaurantUseCaseImpl(
          restaurantRepository: RestaurantRepositoryIml(
            remoteDataSource: RemoteDataSourceImpl(
              dio: Dio(
                BaseOptions(
                  baseUrl: ApiConstant.baseUrl,
                ),
              ),
            ),
          ),
        ),
      )..add(GetListRestaurant()),
      child: Scaffold(
        backgroundColor: CustomColors.yellow,
        appBar: AppBar(
          backgroundColor: CustomColors.yellow,
          elevation: 0.0,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Restaurant",
                style: TextStyle(color: CustomColors.white, fontSize: 20.sp),
              ),
              Text(
                "Recommendation restaurant for you!",
                style: TextStyle(color: CustomColors.white, fontSize: 12.sp),
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: CustomColors.white,
              ),
            ),
          ],
        ),
        body: BlocBuilder<GetListRestaurantBloc, GetListRestaurantState>(
          builder: (context, state) {
            if (state is GetListRestaurantLoadedState) {
              if (state.listRestaurant.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: CustomColors.lightYellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: CustomErrorWidget(
                    errorImage: ImageStrings.empty,
                    errorMessage: "Restaurant data is empty",
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(top: 16.w),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: CustomColors.lightYellow,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.listRestaurant.length,
                          itemBuilder: (context, index) {
                            return RestaurantCard(
                                restaurantEntity: state.listRestaurant[index]);
                          })),
                );
              }
            } else if (state is GetListRestaurantFailedState) {
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: CustomColors.lightYellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: CustomErrorWidget(
                  errorImage: ImageStrings.error,
                  errorMessage: "An error occurred please try again later",
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: CustomColors.lightYellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: CustomLoadingProgress(),
              );
            }
          },
        ),
      ),
    );
  }
}