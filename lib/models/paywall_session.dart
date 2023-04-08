import 'dart:ffi';

class PaywallSession {

  String paywallId;
  Int count;
  
  PaywallSession({
    required this.paywallId,
    required this.count,
  });

  factory PaywallSession.fromJson(Map<String, dynamic> json) {
    return new PaywallSession(
      paywallId: json['paywall_id'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paywall_id'] = paywallId;
    data['count'] = count;
    return data;
  }
}