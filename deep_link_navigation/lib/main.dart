import 'package:flutter/material.dart';

// Model class representing an item
class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

// ---------------------------
// Route path configuration
// ---------------------------
class RoutePath {
  final bool isHome;
  final int? id;
  final bool isSettings;

  RoutePath.home()
      : isHome = true,
        id = null,
        isSettings = false;

  RoutePath.detail(this.id)
      : isHome = false,
        isSettings = false;

  RoutePath.settings()
      : isHome = false,
        id = null,
        isSettings = true;

  bool get isDetail => id != null;
}

// ---------------------------
// Route information parser
// ---------------------------
class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    // Handle root (/)
    if (uri.pathSegments.isEmpty) {
      return RoutePath.home();
    }

    // Handle /settings
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'settings') {
      return RoutePath.settings();
    }

    // Handle /detail/:id
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'detail') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return RoutePath.detail(id);
      }
    }

    // Fallback to home for unrecognised routes
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

// ---------------------------
// Router delegate
// ---------------------------
class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int? _selectedItemId;
  bool _showSettings = false;

  final List<Item> _items = [
    Item(id: 1, name: 'Item 1'),
    Item(id: 2, name: 'Item 2'),
    Item(id: 3, name: 'Item 3'),
  ];

  // -------- Navigation helpers --------
  void selectItem(int id) {
    _selectedItemId = id;
    _showSettings = false;
    notifyListeners();
  }

  void goHome() {
    _selectedItemId = null;
    _showSettings = false;
    notifyListeners();
  }

  void goToSettings() {
    _selectedItemId = null;
    _showSettings = true;
    notifyListeners();
  }

  // -------- RouterDelegate overrides --------
  @override
  RoutePath get currentConfiguration {
    if (_showSettings) {
      return RoutePath.settings();
    }
    if (_selectedItemId != null) {
      return RoutePath.detail(_selectedItemId);
    }
    return RoutePath.home();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // Home page – always present
        MaterialPage(
          key: const ValueKey('HomeScreen'),
          child: HomeScreen(
            items: _items,
            onItemSelected: selectItem,
            onSettingsTapped: goToSettings,
          ),
        ),
        // Detail page
        if (_selectedItemId != null)
          MaterialPage(
            key: ValueKey('DetailScreen-$_selectedItemId'),
            child: DetailScreen(
              item: _items.firstWhere((item) => item.id == _selectedItemId),
              onBack: goHome,
            ),
          ),
        // Settings page
        if (_showSettings)
          const MaterialPage(
            key: ValueKey('SettingsScreen'),
            child: SettingsScreen(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        // If settings is visible, close it – otherwise go home
        if (_showSettings) {
          _showSettings = false;
        } else {
          _selectedItemId = null;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    if (path.isHome) {
      _selectedItemId = null;
      _showSettings = false;
    } else if (path.isDetail && path.id != null) {
      _selectedItemId = path.id;
      _showSettings = false;
    } else if (path.isSettings) {
      _selectedItemId = null;
      _showSettings = true;
    }
  }
}

// ---------------------------
// Main application
// ---------------------------
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
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}

// ---------------------------
// Home screen
// ---------------------------
class HomeScreen extends StatelessWidget {
  final List<Item> items;
  final Function(int) onItemSelected;
  final VoidCallback onSettingsTapped;

  const HomeScreen({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.onSettingsTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: onSettingsTapped,
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

// ---------------------------
// Detail screen
// ---------------------------
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

// ---------------------------
// Settings screen
// ---------------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}