import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infoshots/providers/favourites_provider.dart';
import 'package:infoshots/screens/webview.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});
  @override
  ConsumerState<FavouritesScreen> createState() {
    return _FavouritesScreenState();
  }
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  late Future<void> _favouritesList;

  @override
  void initState() {
    super.initState();
    _favouritesList = ref.read(favouritesProvider.notifier).loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final myFavourites = ref.watch(favouritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body: FutureBuilder(
        future: _favouritesList,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: myFavourites.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(right: 8),
                    alignment: Alignment.centerRight,
                    color: Colors.red.shade300,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  key: ValueKey(myFavourites[index].pageId),
                  onDismissed: (direction) {
                    ref
                        .read(favouritesProvider.notifier)
                        .removeWiki(myFavourites[index]);
                    setState(() {
                      myFavourites.remove(myFavourites[index]);
                    });
                  },
                  child: ListTile(
                    title: Text(myFavourites[index].title),
                    subtitle: Text(
                      myFavourites[index].extract,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              WebView(title: myFavourites[index].title),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
