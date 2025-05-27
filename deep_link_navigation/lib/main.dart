import 'package:flutter/material.dart';

// Kelas untuk merepresentasikan data item
class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

// Kelas untuk parsing informasi rute
class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    // Menangani rute root (/)
    if (uri.pathSegments.isEmpty) {
      return RoutePath.home();
    }

    // Menangani rute /detail/:id
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'detail') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return RoutePath.detail(id);
      }
    }

    // Menangani rute /settings
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'settings') {
      return RoutePath.settings();
    }

    // Kembali ke home jika rute tidak dikenali
    return RoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    if (path.isHome) {
      return RouteInformation(uri: Uri.parse('/'));
    }
    if (path.isDetail) {
      return RouteInformation(uri: Uri.parse('/detail/${path.id}'));
    }
    if (path.isSettings) {
      return RouteInformation(uri: Uri.parse('/settings'));
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}

// Kelas untuk konfigurasi rute
class RoutePath {
  final bool isHome;
  final bool isSettings;
  final int? id;

  RoutePath.home()
      : isHome = true,
        isSettings = false,
        id = null;

  RoutePath.detail(this.id) : isHome = false, isSettings = false;

  RoutePath.settings() : isHome = false, isSettings = true, id = null;

  bool get isDetail => !isHome && !isSettings;
}

// Kelas untuk router delegate
class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int? _selectedItemId;
  final List<Item> _items = [
    Item(id: 1, name: 'Item 1'),
    Item(id: 2, name: 'Item 2'),
    Item(id: 3, name: 'Item 3'),
  ];

  // Mengatur item yang dipilih
  void selectItem(int id) {
    _selectedItemId = id;
    notifyListeners();
  }

  // Kembali ke home
  void goHome() {
    _selectedItemId = null;
    notifyListeners();
  }

  // Navigasi ke settings
  void goSettings() {
    _selectedItemId = null;
    notifyListeners();
  }

  @override
  RoutePath get currentConfiguration {
    if (_selectedItemId == null) {
      return RoutePath.home();
    }
    return RoutePath.detail(_selectedItemId);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // Selalu tampilkan HomeScreen
        MaterialPage(
          key: const ValueKey('HomeScreen'),
          child: HomeScreen(
            items: _items,
            onItemSelected: selectItem,
            onSettingsTapped: goSettings, // Pass goSettings to HomeScreen
          ),
        ),
        // Tampilkan DetailScreen jika ada item yang dipilih
        if (_selectedItemId != null)
          MaterialPage(
            key: ValueKey('DetailScreen-$_selectedItemId'),
            child: DetailScreen(
              item: _items.firstWhere((item) => item.id == _selectedItemId),
              onBack: goHome,
            ),
          ),
        // Tampilkan SettingsScreen jika dipilih
        if (_selectedItemId == null && currentConfiguration.isSettings)
          MaterialPage(
            key: const ValueKey('SettingsScreen'),
            child: SettingsScreen(
              onBack: goHome,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        goHome();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    if (path.isHome) {
      _selectedItemId = null;
    } else if (path.isDetail && path.id != null) {
      _selectedItemId = path.id;
    } else if (path.isSettings) {
      _selectedItemId = null;
    }
  }
}

// Halaman pengaturan (SettingsScreen)
class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Settings Page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Layar Utama (HomeScreen)
class HomeScreen extends StatelessWidget {
  final List<Item> items;
  final Function(int) onItemSelected;
  final VoidCallback onSettingsTapped; // Callback untuk pengaturan

  const HomeScreen({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.onSettingsTapped, // Terima callback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          // Tombol pengaturan menggunakan IconButton
          IconButton(
            icon: const Icon(Icons.settings), // Ikon gear
            onPressed: onSettingsTapped, // Panggil callback untuk navigasi ke Settings
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('ID: ${item.id}'),
            onTap: () => onItemSelected(item.id),
            trailing: const Icon(Icons.arrow_forward),
          );
        },
      ),
    );
  }
}

// Layar Detail (DetailScreen)
class DetailScreen extends StatelessWidget {
  final Item item;
  final VoidCallback onBack;

  const DetailScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail: ${item.name}'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Item: ${item.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'ID: ${item.id}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Aplikasi utama
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Deep Linking App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}
