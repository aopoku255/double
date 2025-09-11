import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShortVideos extends StatefulWidget {
  const ShortVideos({super.key});

  @override
  State<ShortVideos> createState() => _ShortVideosState();
}

class _ShortVideosState extends State<ShortVideos> {
  List<Map<String, String>> videos = [];
  bool isLoading = true;
  PageController pageController = PageController();
  List<YoutubePlayerController> controllers = [];

  @override
  void initState() {
    super.initState();
    fetchYouTubeShorts();
  }

  /// 🔹 Fetch YouTube Shorts dynamically
  Future<void> fetchYouTubeShorts() async {
    const apiKey = "AIzaSyBZs6FU8HYMMYmErzZDUwzsIwIWuYhO7H4"; // replace with your key
    const channelId = "UCnqPYYHjAfCxjBTQFRXdahw";

    final url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&type=video&order=date&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      setState(() {
        videos = items.map((item) {
          final id = item['id']['videoId'] as String;
          final title = item['snippet']['title'] as String;
          return {"id": id, "title": title};
        }).toList();

        // create controllers
        controllers = videos.map((v) {
          return YoutubePlayerController(
            initialVideoId: v["id"]!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              loop: true,
            ),
          );
        }).toList();

        // autoplay the first video
        if (controllers.isNotEmpty) {
          controllers[0].play();
        }

        isLoading = false;
      });
    } else {
      debugPrint(response.body);
      throw Exception("Failed to load YouTube videos");
    }
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        onPageChanged: (index) {
          for (int i = 0; i < controllers.length; i++) {
            if (i == index) {
              controllers[i].play(); // play current
            } else {
              controllers[i].pause(); // pause others
            }
          }
        },
        itemBuilder: (context, index) {
          final video = videos[index];
          final controller = controllers[index];

          return Stack(
            children: [
              Positioned.fill(
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 120,
                child: Text(
                  video["title"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 6,
                        color: Colors.black87,
                      )
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
