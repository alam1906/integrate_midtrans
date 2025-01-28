import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

/// Simpan daftar semua WebSocket clients.
final connectedClients = <WebSocketChannel>[];

Handler middleware(Handler handler) {
  return webSocketHandler((channel, protocol) {
    // Tambahkan koneksi baru ke daftar
    connectedClients.add(channel);
    print('Client connected: ${connectedClients.length}');

    // Dengarkan pesan dari client
    channel.stream.listen(
      (message) {
        print('Received message from client: $message');
        // Kirim balik pesan atau tambahkan logika lain di sini
        channel.sink.add('Echo: $message');
      },
      onDone: () {
        // Hapus koneksi saat client terputus
        connectedClients.remove(channel);
        print('Client disconnected: ${connectedClients.length}');
      },
    );
  });
}
