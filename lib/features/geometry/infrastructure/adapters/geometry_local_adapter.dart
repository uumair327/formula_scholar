import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Local adapter: returns hardcoded geometry data for development.
///
/// Driven adapter implementing [GeometryDataSourcePort].
@LazySingleton(as: GeometryDataSourcePort)
class GeometryLocalAdapter implements GeometryDataSourcePort {
  @override
  Future<List<GeometryTopic>> getTopics() async {
    AppLogger.trace(
      'getTopics() fetching local data',
      tag: AppLogTags.geometryDataSource,
    );
    return const [
      GeometryTopic(
        id: 'triangles',
        name: AppStrings.triangles,
        subtitle: AppStrings.trianglesSubtitle,
        completedFormulas: 4,
        totalFormulas: 5,
        progressPercent: 80,
      ),
      GeometryTopic(
        id: 'circles',
        name: AppStrings.circles,
        subtitle: AppStrings.circlesSubtitle,
        completedFormulas: 2,
        totalFormulas: 5,
        progressPercent: 40,
      ),
      GeometryTopic(
        id: 'quadrilaterals',
        name: AppStrings.quadrilaterals,
        subtitle: AppStrings.quadrilateralsSubtitle,
        completedFormulas: 0,
        totalFormulas: 6,
        progressPercent: 0,
      ),
      GeometryTopic(
        id: 'coordinates',
        name: AppStrings.coordinates,
        subtitle: AppStrings.coordinatesSubtitle,
        completedFormulas: 0,
        totalFormulas: 4,
        progressPercent: 0,
      ),
      GeometryTopic(
        id: 'polygons',
        name: AppStrings.advancedPolygons,
        subtitle: AppStrings.advancedPolygonsSubtitle,
        completedFormulas: 0,
        totalFormulas: 0,
        progressPercent: 0,
      ),
    ];
  }
}
