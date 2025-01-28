// /routes/midtrans/token.dart
import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  // Midtrans server key
  const serverKey = 'SB-Mid-server-LPJjngR7hxTvGlCRziUTX7w_';
  const midtransUrl = 'https://app.sandbox.midtrans.com/snap/v1/transactions';

  // Parsing request body
  final body = await context.request.json() as Map<String, dynamic>;

  // Transaction details
  final transactionDetails = {
    'transaction_details': {
      'order_id': body['order_id'],
      'gross_amount': body['gross_amount'],
    },
    'customer_details': {
      'first_name': body['first_name'],
      'email': body['email'],
    },
  };

  // HTTP request to Midtrans
  final response = await http.post(
    Uri.parse(midtransUrl),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$serverKey:'))}',
    },
    body: jsonEncode(transactionDetails),
  );

  // Check response status
  if (response.statusCode == 201) {
    final snapResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return Response.json(body: {'snap_token': snapResponse['token']});
  } else {
    return Response.json(
      statusCode: response.statusCode,
      body: {'error': 'Failed to create transaction'},
    );
  }
}
