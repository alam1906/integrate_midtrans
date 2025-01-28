import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import 'websocket.dart'; // Akses daftar `connectedClients`

Future<Response> onRequest(RequestContext context) async {
  // Pastikan metode request adalah POST
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  final body = await context.request.body();
  final data = jsonDecode(body);

  final orderId = data['order_id'] as String?;
  final transactionStatus = data['transaction_status'] as String?;

  if (orderId == null || transactionStatus == null) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Invalid payload'},
    );
  }

  print('Order ID: $orderId, Status: $transactionStatus');

  // Kirim data ke semua klien WebSocket
  for (final client in connectedClients) {
    client.sink.add(jsonEncode({
      'orderId': orderId,
      'transactionStatus': transactionStatus,
    }));
  }

  return Response.json(
    body: {'message': 'Webhook received'},
  );
}
