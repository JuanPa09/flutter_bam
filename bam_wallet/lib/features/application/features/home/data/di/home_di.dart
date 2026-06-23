import 'package:bam_wallet/features/application/features/home/data/data_sources/home_data_source.dart';
import 'package:bam_wallet/features/application/features/home/data/data_sources/home_local_data_source.dart';
import 'package:bam_wallet/features/application/features/home/data/repositories/home_repository_impl.dart';
import 'package:bam_wallet/features/application/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Único archivo que conoce las implementaciones concretas de Data.
/// Expone abstracciones hacia arriba para que Presentation nunca dependa de Data.
final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeLocalDataSource();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(dataSource: ref.watch(homeDataSourceProvider));
});
