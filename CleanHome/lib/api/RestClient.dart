import 'package:cleanhome/api/models/AddressModel.dart';
import 'package:cleanhome/api/models/NewModel.dart';
import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/UserListModel.dart';

part 'RestClient.g.dart';
//147.45.106.167
@RestApi(baseUrl: 'http://147.45.106.167:8080/api/v1/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @GET('login')
  Future<UserModel> login(@Header('Authorization') String token, @Query('role') String role, @Query("region") String regionId, @Query("notifyId") String notifyId);
  @GET('role')
  Future<List<String>> getRole(@Header('Authorization') String token);
  @GET('logout')
  Future<String> logout(@Header('Authorization') String token);
  @GET("region")
  Future<List<RegionModel>> regions();
  @GET("user")
  Future<UserModel> userInfo(@Header('Authorization') String token);
  @GET("region/{id}/news")
  Future<List<NewModel>> regionNews(@Header('Authorization') String token, @Path("id")String id);
  @GET("region/{id}/options")
  Future<List<OptionModel>> getOptions(@Header('Authorization') String token, @Path("id") String id);
  @GET("region/{id}/managers")
  Future<List<UserModel>> getMenegers(@Header('Authorization') String token, @Path("id") String id);
  @GET("region/getAllUsers")
  Future<List<UserModel>> getAllUsers(@Header('Authorization') String token,@Query("search")String? search);
  @POST("region/{id}/addManager")
  Future<String> addManager(@Header('Authorization') String token,@Path("id")String regionId, @Query("id")String userId);
  @POST("region/deleteManager")
  Future<String> deleteManager(@Header('Authorization') String token,@Query("id")String id);
  @GET("region/{id}/users")
  Future<UserListModel> getUsers(@Header('Authorization')String token,@Path("id") String id, @Query("search")String? search);
  @POST("region/{id}/deleteOption")
  Future<String> deleteOption(@Header('Authorization') String token, @Path("id") String region_id, @Query("id")String id);
  @POST("region/create")
  Future<String> createRegion(@Header('Authorization') String token, @Query("name") String name, @Query("priceRoom")double priceRoom,@Query("priceBathroom")double priceBathroom, @Query("priceSize")double priceSize);
  @POST("region/{id}/pushOption")
  Future<String> addOption(@Header('Authorization') String token, @Path("id") String region_id,@Query("name")String name, @Query("description")String? description,@Query("price")double price);
  @POST("region/{id}/edit")
  Future<String> editRegion(@Header('Authorization') String token, @Path("id")String id, @Query("pricedRoom") double priceRoom, @Query("priceBathRoom")double priceBathRoom, @Query("priceSize")double priceSize);
  @GET("user/orders")
  Future<List<OrderModel>> findOrders(@Header('Authorization') String token);
  @GET("user/ordersDone")
  Future<List<OrderModel>> findOrdersDone(@Header('Authorization') String token);
  @POST("user/notifyUpdate")
  Future<String> notifyUpdate(@Header('Authorization') String token, @Query("notifyToken") String notifyToken);
  @POST("user/orders/push")
  Future<OrderModel> pushOrder(@Header('Authorization') String token, @Query("countRoom")int countRoom, @Query("countBathroom")int countBathroom,@Query("address") String address,@Query("startDate") DateTime startDate,@Query("customPrice")double? customPrice,@Query("size")double? size, @Query("options")List<String> options);
  @POST("user/orders/{id}/cancel")
  Future<String> cancelOrder(@Header('Authorization')String token, @Path("id") String id);
  @POST("user/delete")
  Future<String> deleteUser(@Header('Authorization')String token, @Query("id")String? id);
  @GET("user/addresses")
  Future<List<AddressModel>> userAddresses(@Header('Authorization') String token);
  @POST("user/addresses/{id}/delete")
  Future<String> userAddressesDelete(@Header('Authorization') String token, @Path("id")String id);
  @POST("user/addresses/push")
  Future<UserModel> pushAddress(@Header('Authorization') String token,@Query("street")String street, @Query("house")String house,@Query("frame")String frame,@Query("entrance")String entrance,@Query("apartment")String apartment,@Query("intercom")String intercom,@Query("floor")String floor);
  @GET("cleaner/findOrders")
  Future<List<OrderModel>> findOrdersToCleaner(@Header('Authorization') String token);
  @POST("cleaner/selectOrder")
  Future<String> selectOrderToCleaner(@Header('Authorization') String token, @Query("order")String id);
  @POST("cleaner/startOrder")
  Future<String> startOrder(@Header('Authorization') String token, @Query("order")String id);
  @POST("cleaner/endOrder")
  Future<String> finishOrder(@Header('Authorization') String token, @Query("order")String id);
  @GET("cleaner/orders")
  Future<List<OrderModel>> findOrdersCleaner(@Header('Authorization') String token);
}
