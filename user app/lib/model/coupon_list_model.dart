import 'service_detail_response.dart';

class CouponListResponse {
  List<CouponData> expireCupon;
  List<CouponData> validCupon;

  CouponListResponse({
    this.expireCupon = const <CouponData>[],
    this.validCupon = const <CouponData>[],
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) {
    return CouponListResponse(
      expireCupon: json['expire_cupon'] is List ? List<CouponData>.from(json['expire_cupon'].map((x) => CouponData.fromJson(x))) : [],
      validCupon: json['valid_cupon'] is List ? List<CouponData>.from(json['valid_cupon'].map((x) => CouponData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expire_cupon': expireCupon.map((e) => e.toJson()).toList(),
      'valid_cupon': validCupon.map((e) => e.toJson()).toList(),
    };
  }
}
