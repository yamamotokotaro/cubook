import '../../providers.dart';

class PhoneProvider extends AuthProvider {
  PhoneProvider() : super(providerId: "phone");

  @override
  Map<String, dynamic> getMap() {
    return <String, dynamic>{
      'providerId': providerId,
    };
  }
}
