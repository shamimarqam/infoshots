// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:infoshots/models/wiki.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'favourites.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE favourites_wiki(pageId TEXT PRIMARY KEY, title TEXT, extract TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class FavouritesProviderNotifier extends StateNotifier<List<Wiki>> {
  FavouritesProviderNotifier() : super(const []);

  Future<void> loadFavourites() async {
    final db = await _getDatabase();
    final data = await db.query('favourites_wiki');
    final favourites = data
        .map(
          (row) => Wiki(
            pageId: row['pageId'] as String,
            title: row['title'] as String,
            extract: row['extract'] as String,
          ),
        )
        .toList();
    state = favourites;
  }

  void addWiki(Wiki wiki) async {
    final db = await _getDatabase();
    db.insert('favourites_wiki', {
      'pageId': wiki.pageId,
      'title': wiki.title,
      'extract': wiki.extract,
    });
  }

  void removeWiki(Wiki wiki) async {
    final db = await _getDatabase();
    db.delete('favourites_wiki', where: 'pageId = ?', whereArgs: [wiki.pageId]);
  }

  bool toggleFavourites(Wiki wiki) {
    final idList = [];
    for (final item in state) {
      idList.add(item.pageId);
    }
    final isWikiinFavourite = idList.contains(wiki.pageId);
    if (isWikiinFavourite) {
      state = state.where((w) => w.pageId != w.pageId).toList();
      removeWiki(wiki);
      return false;
    } else {
      addWiki(wiki);
      state = [...state, wiki];
      return true;
    }
  }
}

final favouritesProvider =
    StateNotifierProvider<FavouritesProviderNotifier, List<Wiki>>(
      (ref) => FavouritesProviderNotifier(),
    );
