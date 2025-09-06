import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String fixedUsername = "annu";
  final String fixedPassword = "2025";

  void _login(BuildContext context) {
    String username = userIDController.text;
    String password = passwordController.text;
    if (username == fixedUsername && password == fixedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid username or password"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FF), Colors.white, Color(0xFFE8DFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Attendance Monitoring App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF9333EA)],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your details to Login",
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 3, 3, 3)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: userIDController,
                          decoration: InputDecoration(
                            labelText: "User ID",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  List<LatLng> geofencePoints = [
    LatLng(12.917009, 80.173906),
    LatLng(12.917126, 80.173984),
    LatLng(12.917053, 80.174224),
    LatLng(12.916921, 80.174199),
    LatLng(12.916844, 80.174133),
    LatLng(12.916875, 80.173999),
  ];

  void _onBottomNavItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            children: [
              MapScreen(geofencePoints: geofencePoints),
              RecordsScreen(geofencePoints: geofencePoints),
              EmployeeInfoForm(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: _onBottomNavItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Employee Info',
            ),
          ],
          selectedItemColor: const Color.fromARGB(255, 138, 83, 151),
          unselectedItemColor: Colors.grey[600],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final List<LatLng> geofencePoints;

  MapScreen({required this.geofencePoints});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng myCurrentLocation = LatLng(12.916947, 80.174134);
  Location location = Location();

  LatLng _getGeofenceCenter() {
    double latSum = 0;
    double lngSum = 0;

    for (LatLng point in widget.geofencePoints) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }

    return LatLng(latSum / widget.geofencePoints.length,
        lngSum / widget.geofencePoints.length);
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        myCurrentLocation =
            LatLng(userLocation.latitude!, userLocation.longitude!);
      });

      _moveCamera(_getGeofenceCenter());
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _moveCamera(LatLng location) {
    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newLatLng(location));
    }
  }

  void _zoomIntoGeofence() {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(_getGeofenceCenter(), 16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white, Colors.purple[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _getGeofenceCenter(),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _zoomIntoGeofence();
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              polygons: {
                Polygon(
                  polygonId: PolygonId("geofence"),
                  points: widget.geofencePoints,
                  strokeColor: Colors.blue,
                  strokeWidth: 2,
                  fillColor: Color(0x4C2196F3),
                ),
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Map Screen',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.blue[600]!, Colors.purple[600]!],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: _zoomIntoGeofence,
                child: Icon(Icons.location_searching),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordsScreen extends StatefulWidget {
  final List<LatLng> geofencePoints;

  RecordsScreen({required this.geofencePoints});

  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<String> records = [];
  bool isInsideGeofence = false;
  late DateTime currentInTime;
  late DateTime currentOutTime;
  late Timer timer;
  bool isLoading = true;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startTracking() async {
    setState(() {
      isLoading = true;
    });

    var currentLocation = await location.getLocation();
    LatLng currentLatLng =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);

    bool insideGeofence = _isInsideGeofence(currentLatLng);

    DateTime currentTime = DateTime.now();
    if (insideGeofence) {
      currentInTime = currentTime;
      records.add("Status: Inside | In-Time: ${currentInTime.toLocal()}");
    } else {
      currentOutTime = currentTime;
      records.add("Status: Outside | Out-Time: ${currentOutTime.toLocal()}");
    }

    setState(() {
      isLoading = false;
      isInsideGeofence = insideGeofence;
    });

    timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      var currentLocation = await location.getLocation();
      LatLng currentLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      bool insideGeofence = _isInsideGeofence(currentLatLng);
      DateTime currentTime = DateTime.now();

      if (insideGeofence != isInsideGeofence) {
        setState(() {
          if (insideGeofence) {
            currentInTime = currentTime;
            records.add("Status: Inside | In-Time: ${currentInTime.toLocal()}");
          } else {
            currentOutTime = currentTime;
            records
                .add("Status: Outside | Out-Time: ${currentOutTime.toLocal()}");
          }
          isInsideGeofence = insideGeofence;
        });
      }
    });
  }

  bool _isInsideGeofence(LatLng point) {
    int i = 0;
    int j = widget.geofencePoints.length - 1;
    bool inside = false;

    for (i = 0; i < widget.geofencePoints.length; j = i++) {
      double xi = widget.geofencePoints[i].longitude;
      double yi = widget.geofencePoints[i].latitude;
      double xj = widget.geofencePoints[j].longitude;
      double yj = widget.geofencePoints[j].latitude;

      bool intersect = ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
    }

    return inside;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.white, Colors.purple[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white, Colors.purple[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Geofence Records',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.blue[600]!, Colors.purple[600]!],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Geofence status logs',
                        style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 16),
                    records.isEmpty
                        ? Center(child: Text("No records yet"))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(records[index]),
                              );
                            },
                          ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white, Colors.purple[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Employee Information',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.blue[600]!, Colors.purple[600]!],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Icon(
                      FontAwesomeIcons.user,
                      size: 80,
                      color: Colors.blue[400],
                    ),
                    SizedBox(height: 16),
                    Text('Employee details',
                        style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 16),
                    _buildTextField('Name', FontAwesomeIcons.user),
                    _buildDateField(
                        'Date of Birth', FontAwesomeIcons.calendar, context),
                    _buildTextField('Employee ID', FontAwesomeIcons.idCard),
                    _buildTextField('Blood Group', Icons.water_drop),
                    _buildTextField('Mobile Number', FontAwesomeIcons.phone),
                    _buildTextField('Address', Icons.location_on),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Save Information',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(String label, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );
}

Widget _buildDateField(String label, IconData icon, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {}
      },
    ),
  );
}
