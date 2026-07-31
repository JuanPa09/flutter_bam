import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/main.dart';

void main() async {
  Env.environment = Environment.development;
  await runProject();
}
