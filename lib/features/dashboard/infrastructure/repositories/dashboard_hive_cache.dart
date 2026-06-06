import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';

@LazySingleton(as: DashboardCachePort)
class DashboardHiveCache implements DashboardCachePort {
  static const String _boxName = 'dashboard_cache';
  static const String _progressKey = 'study_progress';
  static const String _recentStudiesKey = 'recent_studies';
  static const String _bannersKey = 'banners';
  static const String _announcementsKey = 'announcements';
  static const String _weakAreasKey = 'weak_areas';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _subjectsKey(String boardId, String gradeId) {
    return 'subjects_${boardId}_$gradeId';
  }

  @override
  Future<void> cacheStudyProgress(StudyProgress progress) async {
    final box = await _box();
    await box.put(_progressKey, {
      'masteryPercentage': progress.masteryPercentage,
      'completedChapters': progress.completedChapters,
      'totalChapters': progress.totalChapters,
    });
  }

  @override
  Future<void> cacheSubjects(
    String boardId,
    String gradeId,
    List<Subject> subjects,
  ) async {
    final box = await _box();
    await box.put(
      _subjectsKey(boardId, gradeId),
      subjects
          .map(
            (subject) => {
              'id': subject.id,
              'name': subject.name,
              'description': subject.description,
              'category': subject.category,
              'imageUrl': subject.imageUrl,
              'unitCount': subject.unitCount,
              'formulaCount': subject.formulaCount,
              'iconName': subject.iconName,
              'colorValue': subject.colorValue,
              'badgeText': subject.badgeText,
              'subtitle': subject.subtitle,
              'masteryPercentage': subject.masteryPercentage,
              'lastViewed': subject.lastViewed,
              'isFeatured': subject.isFeatured,
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> cacheBanners(List<CarouselItem> banners) async {
    final box = await _box();
    await box.put(
      _bannersKey,
      banners
          .map(
            (b) => {
              'id': b.id,
              'title': b.title,
              'imageUrl': b.imageUrl,
              'link': b.link,
              'isActive': b.isActive,
              'displayOrder': b.displayOrder,
              'bgColor': b.bgColor,
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> cacheRecentStudies(List<RecentStudy> studies) async {
    final box = await _box();
    await box.put(
      _recentStudiesKey,
      studies
          .map(
            (study) => {
              'id': study.id,
              'subjectId': study.subjectId,
              'title': study.title,
              'subject': study.subject,
              'lastViewed': study.lastViewed,
              'iconName': study.iconName,
              'colorValue': study.colorValue,
              'backgroundColorValue': study.backgroundColorValue,
            },
          )
          .toList(),
    );
  }

  @override
  Future<StudyProgress?> getStudyProgress() async {
    final box = await _box();
    final data = box.get(_progressKey) as Map<dynamic, dynamic>?;
    if (data == null) {
      return null;
    }

    return StudyProgress(
      masteryPercentage: (data['masteryPercentage'] as num?)?.toDouble() ?? 0,
      completedChapters: (data['completedChapters'] as num?)?.toInt() ?? 0,
      totalChapters: (data['totalChapters'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<Subject>> getSubjects(String boardId, String gradeId) async {
    final box = await _box();
    final cached = box.get(_subjectsKey(boardId, gradeId)) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => Subject(
            id: item['id'] as String? ?? '',
            name: item['name'] as String? ?? '',
            description: item['description'] as String? ?? '',
            category: item['category'] as String? ?? '',
            imageUrl: item['imageUrl'] as String? ?? '',
            unitCount: (item['unitCount'] as num?)?.toInt() ?? 0,
            formulaCount: (item['formulaCount'] as num?)?.toInt() ?? 0,
            iconName: item['iconName'] as String? ?? 'book-open',
            colorValue: (item['colorValue'] as num?)?.toInt() ?? 0xFF00639A,
            badgeText: item['badgeText'] as String?,
            subtitle: item['subtitle'] as String?,
            masteryPercentage: (item['masteryPercentage'] as num?)?.toDouble(),
            lastViewed: item['lastViewed'] as String?,
            isFeatured: item['isFeatured'] as bool? ?? false,
          ),
        )
        .toList();
  }

  @override
  Future<List<CarouselItem>> getBanners() async {
    final box = await _box();
    final cached = box.get(_bannersKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => CarouselItem(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            imageUrl: item['imageUrl'] as String? ?? '',
            link: item['link'] as String? ?? '',
            isActive: item['isActive'] as bool? ?? false,
            displayOrder: item['displayOrder'] as int?,
            bgColor: item['bgColor'] as String?,
          ),
        )
        .toList();
  }

  @override
  Future<void> cacheAnnouncements(List<AppAnnouncement> announcements) async {
    final box = await _box();
    await box.put(
      _announcementsKey,
      announcements
          .map(
            (a) => {
              'id': a.id,
              'title': a.title,
              'message': a.message,
              'priority': a.priority,
              'status': a.status,
              'publishAt': a.publishAt,
              'expiresAt': a.expiresAt,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<AppAnnouncement>> getAnnouncements() async {
    final box = await _box();
    final cached = box.get(_announcementsKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => AppAnnouncement(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            message: item['message'] as String? ?? '',
            priority: item['priority'] as String? ?? 'normal',
            status: item['status'] as String? ?? 'draft',
            publishAt: item['publishAt'] as String?,
            expiresAt: item['expiresAt'] as String?,
          ),
        )
        .toList();
  }

  @override
  Future<List<RecentStudy>> getRecentStudies() async {
    final box = await _box();
    final cached = box.get(_recentStudiesKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => RecentStudy(
            id: item['id'] as String? ?? '',
            subjectId: item['subjectId'] as String? ?? '',
            title: item['title'] as String? ?? '',
            subject: item['subject'] as String? ?? '',
            lastViewed: item['lastViewed'] as String? ?? '',
            iconName: item['iconName'] as String? ?? 'book-open',
            colorValue: (item['colorValue'] as num?)?.toInt() ?? 0xFF00639A,
            backgroundColorValue:
                (item['backgroundColorValue'] as num?)?.toInt() ?? 0xFFCEE5FF,
          ),
        )
        .toList();
  }

  @override
  Future<void> cacheWeakAreas(List<WeakArea> areas) async {
    final box = await _box();
    await box.put(
      _weakAreasKey,
      areas
          .map(
            (a) => {
              'category': a.category,
              'subjectName': a.subjectName,
              'totalAttempts': a.totalAttempts,
              'correctAttempts': a.correctAttempts,
              'iconName': a.iconName,
              'colorValue': a.colorValue,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<WeakArea>> getWeakAreas() async {
    final box = await _box();
    final cached = box.get(_weakAreasKey) as List<dynamic>?;
    if (cached == null) return const [];

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => WeakArea(
            category: item['category'] as String? ?? '',
            subjectName: item['subjectName'] as String? ?? '',
            totalAttempts: (item['totalAttempts'] as num?)?.toInt() ?? 0,
            correctAttempts: (item['correctAttempts'] as num?)?.toInt() ?? 0,
            iconName: item['iconName'] as String? ?? 'book-open',
            colorValue: (item['colorValue'] as num?)?.toInt() ?? 0xFF00639A,
          ),
        )
        .toList();
  }
}
