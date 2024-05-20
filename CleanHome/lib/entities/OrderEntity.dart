import 'package:cleanhome/api/models/AddressModel.dart';
import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';

class OrderEntity{
  int? countRoom;
  int? countBathroom;
  double priceRoom;
  double priceBathroom;
  double priceSize;
  double? size;
  double? customPrice;
  int hour;
  AddressModel? address;
  List<OptionModel>? options;
  RegionModel? region;
  DateTime? startDate;
  OrderEntity(this.priceRoom, this.priceBathroom, this.hour,this.priceSize, this.region);

  double get price{
    double price = 0;
    if(size==null){
      price = 1000 + countRoom!*priceRoom+countBathroom!*priceBathroom;
    }else{
      price = 1000 + (size!.round()*priceSize);
    }

    if(options!=null && options!.isNotEmpty){
      for(int i = 0; i < options!.length;i++){
        price= price+options![i].price;
      }
    }
    return price;
  }
  double get mainPrice{
    double price = 1000 + countRoom!*priceRoom+countBathroom!*priceBathroom;
    return price;
  }
  String get address_str{
    return "${address!.city},${address!.street}, д.${address!.house}, кв. ${address!.apartment}";
  }
  List<String> get options_str{
    List<String> _options = [];
    for(int i = 0; i < options!.length; i++){
      _options.add(options![i].id);
    }
    if(_options.length<1){
      return List<String>.empty();
    }else{
      return _options;
    }

  }
  void setOptions(List<OptionModel> model){
    options = model;
  }
  void setAddress(AddressModel addressModel){
    address = addressModel;
  }
  void setStartDate(DateTime dateTime){
    startDate = dateTime;
  }
}