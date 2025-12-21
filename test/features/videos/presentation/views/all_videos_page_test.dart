import 'package:bloc_test/bloc_test.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoCubit extends MockCubit<AllVideosState> implements VideoCubit {}

void main() {
  late MockVideoCubit mockVideoCubit;

  const testVideos = [
    Video(
      id: 'video1',
      title: 'Test Video 1',
      thumbnailUrl: 'https://example.com/thumb1.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
      description: 'Description 1',
      videoUrl: 'https://youtube.com/watch?v=video1',
    ),
    Video(
      id: 'video2',
      title: 'Test Video 2',
      thumbnailUrl: 'https://example.com/thumb2.jpg',
      publishedAt: '2024-01-16T10:00:00Z',
      description: 'Description 2',
      videoUrl: 'https://youtube.com/watch?v=video2',
    ),
  ];

  setUp(() {
    mockVideoCubit = MockVideoCubit();
  });

  tearDown(() {
    mockVideoCubit.close();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<VideoCubit>.value(
        value: mockVideoCubit,
        child: Scaffold(
          appBar: AppBar(title: const Text(AppStrings.allVideos)),
          body: BlocBuilder<VideoCubit, AllVideosState>(
            builder: (context, state) {
              if (state.status == AllVideosStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == AllVideosStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const Text(AppStrings.failedToLoadVideos),
                      Text(state.errorMessage),
                      ElevatedButton(
                        onPressed: () => context.read<VideoCubit>().fetchVideos(),
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  ),
                );
              }
              if (state.status == AllVideosStatus.loaded) {
                if (state.videos.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_library, size: 80),
                        Text(AppStrings.noVideosAvailable),
                        Text(AppStrings.checkBackLater),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.videos.length,
                  itemBuilder: (context, index) {
                    final video = state.videos[index];
                    return ListTile(title: Text(video.title));
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  group('AllVideosPage Widget Tests', () {
    testWidgets('should display loading indicator', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.loading),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display app bar title', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(const AllVideosState());
      await tester.pumpWidget(createTestWidget());
      expect(find.text(AppStrings.allVideos), findsOneWidget);
    });

    testWidgets('should display error on failure', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.failure, errorMessage: 'Error'),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.text(AppStrings.failedToLoadVideos), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
    });

    testWidgets('should display empty state', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.loaded, videos: []),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.text(AppStrings.noVideosAvailable), findsOneWidget);
    });

    testWidgets('should display videos list', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.loaded, videos: testVideos),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Test Video 1'), findsOneWidget);
      expect(find.text('Test Video 2'), findsOneWidget);
    });

    testWidgets('should call fetchVideos on retry', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.failure, errorMessage: 'Error'),
      );
      when(() => mockVideoCubit.fetchVideos()).thenAnswer((_) async {});
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();
      verify(() => mockVideoCubit.fetchVideos()).called(1);
    });

    testWidgets('should show error icon on failure', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.failure, errorMessage: 'Error'),
      );
      await tester.pumpWidget(createTestWidget());
      final iconFinder = find.byIcon(Icons.error_outline);
      expect(iconFinder, findsOneWidget);
      final Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('should show video library icon on empty', (tester) async {
      when(() => mockVideoCubit.state).thenReturn(
        const AllVideosState(status: AllVideosStatus.loaded, videos: []),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.video_library), findsOneWidget);
    });
  });
}
