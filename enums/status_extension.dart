enum Status { pending, running, done }

extension StatusX on Status {
  bool get isTerminal => this == Status.done;

  Status next() => switch (this) {
        Status.pending => Status.running,
        Status.running => Status.done,
        Status.done => Status.done,
      };
}

void main() {
  var status = Status.pending;
  for (var i = 0; i < 3; i++) {
    print('$status terminal=${status.isTerminal}');
    status = status.next();
  }
}
