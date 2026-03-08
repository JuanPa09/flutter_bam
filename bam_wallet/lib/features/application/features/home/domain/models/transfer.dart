class Transfer {
  final String id;
  final String fromAccountNumber;
  final String toAccountNumber;
  final String fromHolder;
  final String toHolder;
  final double amount;
  final String currency;
  final DateTime date;
  final bool isOutgoing;

  const Transfer({
    required this.id,
    required this.fromAccountNumber,
    required this.toAccountNumber,
    required this.fromHolder,
    required this.toHolder,
    required this.amount,
    required this.currency,
    required this.date,
    required this.isOutgoing,
  });
}
