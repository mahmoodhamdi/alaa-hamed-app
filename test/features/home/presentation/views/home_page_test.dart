import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/home/presentation/views/home_page.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoSortOption', () {
    test('should have all expected values', () {
      expect(VideoSortOption.values, [
        VideoSortOption.newest,
        VideoSortOption.oldest,
        VideoSortOption.titleAZ,
        VideoSortOption.titleZA,
      ]);
    });

    test('should have correct order', () {
      expect(VideoSortOption.newest.index, 0);
      expect(VideoSortOption.oldest.index, 1);
      expect(VideoSortOption.titleAZ.index, 2);
      expect(VideoSortOption.titleZA.index, 3);
    });

    test('newest should be first enum value', () {
      expect(VideoSortOption.values.first, VideoSortOption.newest);
    });

    test('titleZA should be last enum value', () {
      expect(VideoSortOption.values.last, VideoSortOption.titleZA);
    });

    test('should have 4 values total', () {
      expect(VideoSortOption.values.length, 4);
    });

    test('enum names should be correct', () {
      expect(VideoSortOption.newest.name, 'newest');
      expect(VideoSortOption.oldest.name, 'oldest');
      expect(VideoSortOption.titleAZ.name, 'titleAZ');
      expect(VideoSortOption.titleZA.name, 'titleZA');
    });
  });

  group('Search and Sort Strings', () {
    test('should have search strings defined', () {
      expect(AppStrings.search, isNotEmpty);
      expect(AppStrings.searchEn, isNotEmpty);
      expect(AppStrings.searchVideos, isNotEmpty);
      expect(AppStrings.searchVideosEn, isNotEmpty);
      expect(AppStrings.noSearchResults, isNotEmpty);
      expect(AppStrings.noSearchResultsEn, isNotEmpty);
      expect(AppStrings.noSearchResultsDescription, isNotEmpty);
      expect(AppStrings.noSearchResultsDescriptionEn, isNotEmpty);
      expect(AppStrings.searchResultsCount, isNotEmpty);
      expect(AppStrings.searchResultsCountEn, isNotEmpty);
    });

    test('should have sort strings defined', () {
      expect(AppStrings.sort, isNotEmpty);
      expect(AppStrings.sortEn, isNotEmpty);
      expect(AppStrings.sortNewest, isNotEmpty);
      expect(AppStrings.sortNewestEn, isNotEmpty);
      expect(AppStrings.sortOldest, isNotEmpty);
      expect(AppStrings.sortOldestEn, isNotEmpty);
      expect(AppStrings.sortTitleAZ, isNotEmpty);
      expect(AppStrings.sortTitleAZEn, isNotEmpty);
      expect(AppStrings.sortTitleZA, isNotEmpty);
      expect(AppStrings.sortTitleZAEn, isNotEmpty);
    });

    test('should have correct Arabic sort values', () {
      expect(AppStrings.sort, 'ترتيب');
      expect(AppStrings.sortNewest, 'الأحدث أولاً');
      expect(AppStrings.sortOldest, 'الأقدم أولاً');
      expect(AppStrings.sortTitleAZ, 'العنوان أ-ي');
      expect(AppStrings.sortTitleZA, 'العنوان ي-أ');
    });

    test('should have correct English sort values', () {
      expect(AppStrings.sortEn, 'Sort');
      expect(AppStrings.sortNewestEn, 'Newest First');
      expect(AppStrings.sortOldestEn, 'Oldest First');
      expect(AppStrings.sortTitleAZEn, 'Title A-Z');
      expect(AppStrings.sortTitleZAEn, 'Title Z-A');
    });

    test('should have correct Arabic search values', () {
      expect(AppStrings.search, 'بحث');
      expect(AppStrings.searchVideos, 'ابحث عن فيديو...');
      expect(AppStrings.noSearchResults, 'لا توجد نتائج');
      expect(AppStrings.noSearchResultsDescription, 'جرب كلمات بحث مختلفة');
      expect(AppStrings.searchResultsCount, 'نتيجة');
    });

    test('should have correct English search values', () {
      expect(AppStrings.searchEn, 'Search');
      expect(AppStrings.searchVideosEn, 'Search for a video...');
      expect(AppStrings.noSearchResultsEn, 'No Results Found');
      expect(AppStrings.noSearchResultsDescriptionEn, 'Try different search terms');
      expect(AppStrings.searchResultsCountEn, 'results');
    });
  });

  group('Video Sorting Logic', () {
    const testVideos = [
      Video(
        id: 'video1',
        title: 'Alpha Test Video',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        publishedAt: '2024-01-15T10:00:00Z',
        description: 'Description about flutter',
        videoUrl: 'https://youtube.com/watch?v=video1',
      ),
      Video(
        id: 'video2',
        title: 'Beta Learning Video',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
        publishedAt: '2024-01-20T10:00:00Z',
        description: 'Description about dart',
        videoUrl: 'https://youtube.com/watch?v=video2',
      ),
      Video(
        id: 'video3',
        title: 'Zeta Tutorial',
        thumbnailUrl: 'https://example.com/thumb3.jpg',
        publishedAt: '2024-01-10T10:00:00Z',
        description: 'Description about programming',
        videoUrl: 'https://youtube.com/watch?v=video3',
      ),
    ];

    test('should sort videos by newest first', () {
      final sorted = List<Video>.from(testVideos)
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      expect(sorted[0].id, 'video2'); // Jan 20
      expect(sorted[1].id, 'video1'); // Jan 15
      expect(sorted[2].id, 'video3'); // Jan 10
    });

    test('should sort videos by oldest first', () {
      final sorted = List<Video>.from(testVideos)
        ..sort((a, b) => a.publishedAt.compareTo(b.publishedAt));

      expect(sorted[0].id, 'video3'); // Jan 10
      expect(sorted[1].id, 'video1'); // Jan 15
      expect(sorted[2].id, 'video2'); // Jan 20
    });

    test('should sort videos by title A-Z', () {
      final sorted = List<Video>.from(testVideos)
        ..sort((a, b) => a.title.compareTo(b.title));

      expect(sorted[0].title, 'Alpha Test Video');
      expect(sorted[1].title, 'Beta Learning Video');
      expect(sorted[2].title, 'Zeta Tutorial');
    });

    test('should sort videos by title Z-A', () {
      final sorted = List<Video>.from(testVideos)
        ..sort((a, b) => b.title.compareTo(a.title));

      expect(sorted[0].title, 'Zeta Tutorial');
      expect(sorted[1].title, 'Beta Learning Video');
      expect(sorted[2].title, 'Alpha Test Video');
    });

    test('should filter videos by title search', () {
      const searchQuery = 'alpha';
      final filtered = testVideos.where((video) {
        return video.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filtered.length, 1);
      expect(filtered[0].id, 'video1');
    });

    test('should filter videos by description search', () {
      const searchQuery = 'flutter';
      final filtered = testVideos.where((video) {
        return video.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filtered.length, 1);
      expect(filtered[0].id, 'video1');
    });

    test('should return empty when search finds no matches', () {
      const searchQuery = 'nonexistent';
      final filtered = testVideos.where((video) {
        return video.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            video.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filtered, isEmpty);
    });

    test('search should be case insensitive', () {
      const searchQuery = 'ALPHA';
      final filtered = testVideos.where((video) {
        return video.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filtered.length, 1);
      expect(filtered[0].id, 'video1');
    });

    test('should filter and sort together', () {
      const searchQuery = 'video';

      // Filter by search query
      var filtered = testVideos.where((video) {
        return video.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      // Sort by newest first
      filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      expect(filtered.length, 2); // Alpha and Beta have "Video" in title
      expect(filtered[0].id, 'video2'); // Beta is newer
      expect(filtered[1].id, 'video1'); // Alpha is older
    });

    test('empty search query should return all videos', () {
      const searchQuery = '';
      final filtered = testVideos.where((video) {
        if (searchQuery.isEmpty) return true;
        return video.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filtered.length, 3);
    });
  });

  group('Navigation Tab Labels', () {
    test('should have all navigation labels defined', () {
      expect(AppStrings.allVideos, isNotEmpty);
      expect(AppStrings.playlists, isNotEmpty);
      expect(AppStrings.favorites, isNotEmpty);
      expect(AppStrings.watchHistory, isNotEmpty);
    });

    test('should have correct Arabic tab labels', () {
      expect(AppStrings.allVideos, 'كل الفيديوهات');
      expect(AppStrings.playlists, 'قوائم التشغيل');
      expect(AppStrings.favorites, 'المفضلة');
      expect(AppStrings.watchHistory, 'سجل المشاهدة');
    });

    test('should have correct English tab labels', () {
      expect(AppStrings.allVideosEn, 'All Videos');
      expect(AppStrings.playlistsEn, 'Playlists');
      expect(AppStrings.favoritesEn, 'Favorites');
      expect(AppStrings.watchHistoryEn, 'Watch History');
    });
  });
}
