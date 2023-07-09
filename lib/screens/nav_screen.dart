import 'package:flutter/material.dart';
import 'package:youtube_clone/models/models.dart';
import 'package:youtube_clone/screens/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoprovider = StateProvider<Video?>((ref) => null);
final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController?>(
  (ref) => MiniplayerController(),
);

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;

  int _selectedIndex = 0;
  final List _screens = [
    const HomeScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, watch, _) {
        final selectedVideo = watch(selectedVideoprovider).state;
        final miniplayerController = watch(miniPlayerControllerProvider).state;
        return Stack(
          children: _screens
              .asMap()
              .map(
                (index, screen) => MapEntry(
                  index,
                  Offstage(
                    offstage: _selectedIndex != index,
                    child: screen,
                  ),
                ),
              )
              .values
              .toList()
            ..add(
              Offstage(
                offstage: selectedVideo == null,
                child: Miniplayer(
                  controller: miniplayerController,
                  maxHeight: MediaQuery.of(context).size.height,
                  minHeight: _playerMinHeight,
                  builder: (height, percentage) {
                    if (selectedVideo == null) {
                      return const SizedBox.shrink();
                    }
                    if (height <= _playerMinHeight + 50) {
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  selectedVideo.thumbnailUrl,
                                  height: 56,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            selectedVideo.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            selectedVideo.author.username,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read(selectedVideoprovider).state =
                                        null;
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            const LinearProgressIndicator(
                              value: 0.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                    return const VideoScreen();
                  },
                ),
              ),
            ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore_rounded),
          ),
          BottomNavigationBarItem(
            label: "Add",
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: "Subcription",
            icon: Icon(Icons.subscriptions_rounded),
          ),
          BottomNavigationBarItem(
            label: "Library",
            icon: Icon(Icons.video_library_rounded),
          ),
        ],
      ),
    );
  }
}
