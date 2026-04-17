import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:infoshots/models/wiki.dart';
import 'package:infoshots/providers/favourites_provider.dart';
import 'package:infoshots/screens/about_screen.dart';
import 'package:infoshots/screens/favourites_screen.dart';
import 'package:infoshots/screens/webview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<Wiki> _loadedWiki;

  Future<Wiki> _loadData() async {
    final idUrl = Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnlimit=1&grnminsize=100000&prop=extracts|pageimages|pageprops&piprop=thumbnail&exintro=&explaintext=&pithumbsize=500&ppprop=disambiguation&format=json&formatversion=2',
    );
    final response = await http.get(
      idUrl,
      headers: {
        'User-Agent':
            'Infoshots/1.0 (https://github.com/shamimarqam; shamimarqamw@gmail.com)',
      },
    );
    final data = json.decode(response.body);
    final pageid = data['query']['pages'][0]['pageid'];
    final pageidString = pageid.toString();
    final title = data['query']['pages'][0]['title'];
    final extract = data['query']['pages'][0]['extract'];
    final imageURL = data['query']['pages'][0]['thumbnail'] == null
        ? null
        : data['query']['pages'][0]['thumbnail']['source'];

    return Wiki(
      pageId: pageidString,
      title: title,
      extract: extract,
      imageUrl: imageURL,
    );
  }

  @override
  void initState() {
    super.initState();

    _loadedWiki = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final favouriteWikis = ref.watch(favouritesProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loadedWiki = _loadData();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(Icons.refresh), Text('Next')],
        ),
      ),
      appBar: AppBar(
        title: const Text('Infoshots'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => AboutScreen()));
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _loadedWiki,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: Please try again!'));
          } else if (snapshot.hasData) {
            var noImage = true;
            Widget imageContent = Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('No image', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
            if (snapshot.data!.imageUrl != null ||
                snapshot.data!.imageUrl == '') {
              noImage = false;
              imageContent = Image.network(
                snapshot.data!.imageUrl!,
                width: double.infinity,
              );
            }
            final idList = [];
            for (final item in favouriteWikis) {
              idList.add(item.pageId);
            }
            final isFav = idList.contains(snapshot.data!.pageId);
            double screenHeight = MediaQuery.of(context).size.height;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: noImage ? 60 : screenHeight * 0.4,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(child: imageContent),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withAlpha(
                                      150,
                                    ),
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),

                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    key: ValueKey(isFav),
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(favouritesProvider.notifier)
                                        .toggleFavourites(snapshot.data!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        Text(
                          snapshot.data!.title,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(snapshot.data!.extract),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Information provided by Wikipedia, the free encyclopedia.',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
                BottomNavigationBar(
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return FavouritesScreen();
                          },
                        ),
                      );
                    }
                    if (index == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return WebView(title: snapshot.data!.title);
                          },
                        ),
                      );
                    }
                  },
                  selectedItemColor: Colors.grey.shade700,
                  unselectedItemColor: Colors.grey.shade700,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favourites',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.read_more_rounded),
                      label: 'Read more',
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: Text("No data found!"));
          }
        },
      ),
    );
  }
}
