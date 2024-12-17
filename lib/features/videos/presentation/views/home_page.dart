import 'package:eng_alaa_hammed/core/depandancy_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/videos_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/videos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<VideoCubit>()..fetchVideos(), // استخدام الـ Service Locator هنا
      child: Scaffold(
        appBar: AppBar(title: Text('Videos')),
        body: BlocBuilder<VideoCubit, VideosState>(
          builder: (context, state) {
            if (state.status == VideosStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == VideosStatus.failure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state.status == VideosStatus.loaded) {
              return ListView.builder(
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return ListTile(
                    title: Text(video.title),
                    subtitle: Text(video.publishedAt),
                    leading: Image.network(video.thumbnailUrl),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
