import 'dart:convert';

class TopUpAction {
  final String action; 
  final int value;     

  TopUpAction({
    required this.action,
    required this.value,
  });

  factory TopUpAction.fromJson(Map<String, dynamic> json) {
    return TopUpAction(
      action: json['action'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'value': value,
    };
  }
}


void main() {
  String jsonStr = '''
  {
    "action": "approve",
    "value": 400
  }
  ''';

  final data = jsonDecode(jsonStr);
  TopUpAction action = TopUpAction.fromJson(data);

  print('Action: ${action.action}, Value: ${action.value}');

  // تحويل كائن إلى JSON
  print(jsonEncode(action.toJson()));
}
