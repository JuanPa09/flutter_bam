class BankAccount {
  final String id;
  final String name;
  final String accountNumber;
  final String holderName;
  final double balance;
  final String currency;
  final String status;

  const BankAccount({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.holderName,
    required this.balance,
    required this.currency,
    required this.status,
  });
}
