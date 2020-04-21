import 'package:json_annotation/json_annotation.dart';

part 'token_pair.g.dart';

@JsonSerializable()
class TokenPair {
  TokenPair({this.accessToken, this.refreshToken});

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  factory TokenPair.fromJson(Map<String, dynamic> json) => _$TokenPairFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPairToJson(this);
}