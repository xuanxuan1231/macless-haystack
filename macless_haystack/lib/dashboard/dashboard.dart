import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:macless_haystack/item_management/refresh_action.dart';
import 'package:provider/provider.dart';
import 'package:macless_haystack/accessory/accessory_registry.dart';
import 'package:macless_haystack/dashboard/accessory_map_list_vert.dart';
import 'package:macless_haystack/item_management/item_management.dart';
import 'package:macless_haystack/item_management/new_item_action.dart';
import 'package:macless_haystack/location/location_model.dart';
import 'package:macless_haystack/preferences/preferences_page.dart';
import 'package:macless_haystack/preferences/user_preferences_model.dart';

class Dashboard extends StatefulWidget {
  /// Displays the layout for the mobile view of the app.
  ///
  /// The layout is optimized for a vertically aligned small screens.
  /// The functionality is structured in a bottom tab bar for easy access
  /// on mobile devices.
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  /// A list of the tabs displayed in the bottom tab bar.
  late final List<Map<String, dynamic>> _tabs = [
    {
      'title': '我的设备',
      'body': (ctx) => AccessoryMapListVertical(
            loadLocationUpdates: loadLocationUpdates,
          ),
      'icon': Icons.place,
      'label': '地图',
      'actionButton': (ctx) => RefreshAction(
            callback: loadLocationUpdates,
          ),
    },
    {
      'title': '我的设备',
      'body': (ctx) => const KeyManagement(),
      'icon': Icons.style,
      'label': '设备',
      'actionButton': (ctx) => const NewKeyAction(),
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize models and preferences
    var userPreferences = Provider.of<UserPreferences>(context, listen: false);
    var locationModel = Provider.of<LocationModel>(context, listen: false);
    var locationPreferenceKnown =
        userPreferences.locationPreferenceKnown ?? false;
    var locationAccessWanted = userPreferences.locationAccessWanted ?? false;
    if (!locationPreferenceKnown || locationAccessWanted) {
      locationModel.requestLocationUpdates();
    }

    // Load new location reports on app start
    loadLocationUpdates();
  }

  /// Fetch location updates for all accessories.
  Future<void> loadLocationUpdates() async {
    var accessoryRegistry =
        Provider.of<AccessoryRegistry>(context, listen: false);

    var logger = Logger(
      printer: PrettyPrinter(),
    );

    try {
      var count = await accessoryRegistry.loadLocationReports();
      if (mounted && accessoryRegistry.accessories.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(
              '获取了 $count 个地点',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        );
      }
    } catch (e, stacktrace) {
      logger.e('获取失败', error: e, stackTrace: stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            '找不到地点报告。请稍后再试。Error: ${e.toString()}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      );
    }
  }

  /// The selected tab index.
  int _selectedIndex = 0;

  /// Updates the currently displayed tab to [index].
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的设备'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PreferencesPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _tabs[_selectedIndex]['body'](context),
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab['icon']),
                  label: tab['label'],
                ))
            .toList(),
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).secondaryHeaderColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton:
          _tabs[_selectedIndex]['actionButton']?.call(context),
    );
  }
}
