enum Status { pending, running, done }

String label(Status s) {
  switch (s) {
    case Status.pending:
      return '...';
    case Status.running:
      return '>>';
    case Status.done:
      return 'done';
  }
}

void main() {
  for (final status in Status.values) {
    print('${status.name} -> ${label(status)}');
  }
}
