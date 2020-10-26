import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class ApiConstant {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";
  static const String listRestaurant = "/list";
  static const String detailRestaurant = "/detail/";
  static const String smallImageResolution = "$baseUrl/images/small/";
}

class ImageStrings{
  static const basePath = "assets/images";
  static const logo = "$basePath/logo.png";
  static const error = "$basePath/error.png";
  static const empty = "$basePath/empty.png";
}

class CustomColors{
  static const Color yellow = Color(0xffFFCA60);
  static const Color lightYellow = Color(0xffFEF9EE);
  static const Color white = Color(0xffFFFFFF);
  static const Color grey = Color(0xff707070);
  static const Color darkGrey = Color(0xff444444);
}

class CustomScreenUtils{
  static void initScreenUtils(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 640));
  }
}

class RestaurantListModel extends Equatable {
  final bool error;
  final String message;
  final int count;
  final int found;
  final List<RestaurantModel> restaurants;

  RestaurantListModel({this.restaurants,this.error,this.message,this.count,this.found});

  @override
  List<Object> get props => [restaurants,error,message,count,found];

  factory RestaurantListModel.fromJson(Map<String, dynamic> json) =>
      RestaurantListModel(
        error: json['error'],
        message: json['message'] ?? "",
        count: json['count'] ?? 0,
        found: json['found'] ?? 0,
        restaurants: List<RestaurantModel>.from(json['restaurants']
            .map((restaurant) => RestaurantModel.fromJson(restaurant))),
      );
}

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  RestaurantModel(
      {this.id,
        this.name,
        this.description,
        this.pictureId,
        this.city,
        this.rating});

  @override
  List<Object> get props =>
      [id, name, description, pictureId, city, rating];

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    pictureId: json['pictureId'],
    city: json['city'],
    rating: json['rating'].toDouble(),
  );
}

abstract class RemoteDataSource {
  Future<RestaurantListModel> getRestaurantList();
}

class RemoteDataSourceImpl extends RemoteDataSource {
  Dio dio;

  RemoteDataSourceImpl({this.dio});

  @override
  Future<RestaurantListModel> getRestaurantList() async {
    try {
      Response _response = await dio.get(ApiConstant.listRestaurant);
      return RestaurantListModel.fromJson(_response.data);
    } on DioError catch (e) {
      return RestaurantListModel.fromJson(e.response.data);
    }
  }
}
class RestaurantListEntity extends Equatable {
  final bool error;
  final String message;
  final List<RestaurantEntity> restaurants;

  RestaurantListEntity({this.restaurants, this.message, this.error});

  @override
  List<Object> get props => [restaurants, message, error];
}

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String rating;

  RestaurantEntity(
      {this.id,
        this.name,
        this.description,
        this.pictureId,
        this.city,
        this.rating});

  @override
  List<Object> get props => [id, name, description, pictureId, city, rating];
}

abstract class RestaurantRepository {
  Future<RestaurantListEntity> getListRestaurant();
}

class RestaurantRepositoryIml extends RestaurantRepository {
  RemoteDataSource remoteDataSource;

  RestaurantRepositoryIml({@required this.remoteDataSource});

  @override
  Future<RestaurantListEntity> getListRestaurant() async {
    List<RestaurantEntity> listRestaurant = List<RestaurantEntity>();
    var restaurantData = await remoteDataSource.getRestaurantList();
    restaurantData.restaurants.forEach((restaurant) {
      var restaurantEntity = RestaurantEntity(
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          pictureId:
          "${ApiConstant.smallImageResolution}${restaurant.pictureId}",
          city: restaurant.city,
          rating: restaurant.rating.toString());
      listRestaurant.add(restaurantEntity);
    });

    var restaurantListEntity = RestaurantListEntity(
      error: restaurantData.error,
      message: restaurantData.message ?? "",
      restaurants: listRestaurant,
    );

    return restaurantListEntity;
  }
}

abstract class GetListRestaurantUseCase {
  Future<RestaurantListEntity> getListRestaurant();
}

class GetListRestaurantUseCaseImpl extends GetListRestaurantUseCase {
  RestaurantRepository restaurantRepository;

  GetListRestaurantUseCaseImpl({@required this.restaurantRepository});

  @override
  Future<RestaurantListEntity> getListRestaurant() =>
      restaurantRepository.getListRestaurant();
}

abstract class GetListRestaurantState extends Equatable {
  const GetListRestaurantState();
}

class GetListRestaurantInitialState extends GetListRestaurantState {
  @override
  List<Object> get props => [];
}

class GetListRestaurantLoadingState extends GetListRestaurantState {
  @override
  List<Object> get props => [];
}

class GetListRestaurantLoadedState extends GetListRestaurantState {
  final List<RestaurantEntity> listRestaurant;

  GetListRestaurantLoadedState({this.listRestaurant});

  @override
  List<Object> get props => [listRestaurant];
}

class GetListRestaurantFailedState extends GetListRestaurantState {
  final String message;

  GetListRestaurantFailedState({this.message});

  @override
  List<Object> get props => [message];
}

abstract class GetListRestaurantEvent extends Equatable {
  const GetListRestaurantEvent();
}

class GetListRestaurant extends GetListRestaurantEvent {
  @override
  List<Object> get props => [];
}

class GetListRestaurantBloc
    extends Bloc<GetListRestaurantEvent, GetListRestaurantState> {
  GetListRestaurantUseCase getListRestaurantUseCase;

  GetListRestaurantBloc({this.getListRestaurantUseCase})
      : super(GetListRestaurantInitialState());

  @override
  Stream<GetListRestaurantState> mapEventToState(
      GetListRestaurantEvent event) async* {
    if (event is GetListRestaurant) {
      yield GetListRestaurantLoadingState();
      var listRestaurant = await getListRestaurantUseCase.getListRestaurant();
      if (listRestaurant.error != true) {
        yield GetListRestaurantLoadedState(
            listRestaurant: listRestaurant.restaurants);
      } else {
        yield GetListRestaurantFailedState(message: listRestaurant.message);
      }
    }
  }
}

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

class CustomLoadingProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomScreenUtils.initScreenUtils(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 16.w,left: 32.w, right: 32.w),
          child: Text(
            "Loading restaurant data please wait...",
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
