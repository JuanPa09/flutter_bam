import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/main.dart';

void main(List<String> args) {
  Env.environment = Environment.development;
  runProject();
}
