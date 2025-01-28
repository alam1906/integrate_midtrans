import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

final connectedClients = <WebSocketChannel>[];
Handler get onRequest {
  return webSocketHandler(
    (channel, protocol) {
      connectedClients.add(channel);

      channel.stream.listen(
        (message) {
          channel.sink.add(message.toString());
        },
        onDone: () {
          channel.sink.close();
        },
      );
    },
  );
}
