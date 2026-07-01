import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_page.dart';
import 'screens/itinerary_page.dart';
import 'screens/photo_page.dart';
import 'screens/more_page.dart';
import 'models/trip_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const LoveTravelApp());
}

class LoveTravelApp extends StatefulWidget {
  const LoveTravelApp({super.key});

  @override
  State<LoveTravelApp> createState() => _LoveTravelAppState();
}

class _LoveTravelAppState extends State<LoveTravelApp> {
  TripData? _tripData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('trip_data');
    TripData data;
    if (json != null && json.isNotEmpty) {
      data = TripData.fromJsonString(json);
    } else {
      data = TripData.createDefault();
    }
    setState(() => _tripData = data);
  }

  Future<void> _saveData() async {
    if (_tripData == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trip_data', _tripData!.toJsonString());
  }

  void _onDataChanged(TripData data) {
    _tripData = data;
    _saveData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '爱旅游',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFC0392B),
        scaffoldBackgroundColor: const Color(0xFFFDF6F0),
        fontFamily: null,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC0392B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFC0392B),
          unselectedItemColor: Color(0xFF7F8C8D),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
      ),
      home: _tripData == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : MainScreen(
              tripData: _tripData!,
              onDataChanged: _onDataChanged,
              currentIndex: _currentIndex,
              onTabChanged: (i) => setState(() => _currentIndex = i),
            ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final TripData tripData;
  final ValueChanged<TripData> onDataChanged;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const MainScreen({
    super.key,
    required this.tripData,
    required this.onDataChanged,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(tripData: tripData, onDataChanged: onDataChanged),
      ItineraryPage(tripData: tripData, onDataChanged: onDataChanged),
      PhotoPage(tripData: tripData, onDataChanged: onDataChanged),
      MorePage(tripData: tripData, onDataChanged: onDataChanged),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('爱', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFD4AC0D))),
            Text('旅游', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                tripData.startDate,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: '行程'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), activeIcon: Icon(Icons.camera_alt), label: '拍照'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz), label: '更多'),
        ],
      ),
    );
  }
}
