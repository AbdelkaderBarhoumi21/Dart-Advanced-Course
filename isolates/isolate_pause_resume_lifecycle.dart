import 'dart:async';
import 'dart:isolate';

void _sendNumber(SendPort sp) async {
  int i = 0;
  while (true) {
    i++;
    sp.send(i);

    await Future.delayed(Duration(seconds: 1));
  }
}

void main() async {
  print('Starting......');
  final rp = ReceivePort();
  Isolate isolate = await Isolate.spawn<SendPort>(_sendNumber, rp.sendPort);

  rp.listen((message) {
    print('Message: $message');
  });
  Timer(Duration(seconds: 3), () {
    print('now pause');
    isolate.pause(isolate.pauseCapability);
  });

  Timer(Duration(seconds: 6), () {
    print('now resume');
    isolate.resume(
      isolate.pauseCapability!,
    ); // pauseCapability mean start from the paused place
  });
  Timer(Duration(seconds: 9), () {
    print('now close receive port');
    rp.close();
  });

  Timer(Duration(seconds: 12), () {
    print('now killed');
    isolate.kill(priority: Isolate.immediate);
  });

  print('end of the code ');
}
