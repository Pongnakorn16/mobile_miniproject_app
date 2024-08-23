import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_miniproject_app/config/config.dart';
import 'package:mobile_miniproject_app/models/response/get_trips_res.dart';
import 'package:mobile_miniproject_app/pages/profile.dart';
import 'package:mobile_miniproject_app/pages/trip.dart';

class ShowtripPracticePage extends StatefulWidget {
  int idx = 0;
  ShowtripPracticePage({super.key, required this.idx});

  @override
  State<ShowtripPracticePage> createState() => _ShowtripPracticePageState();
}

class _ShowtripPracticePageState extends State<ShowtripPracticePage> {
  String url = '';
  List<TripsGetRespones> trips = [];
//3. dclare async object
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    //4.Create object loadData
    randomNumbers();
    loadData = loadDataAsync();
    // getTrips();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 2.0, left: 16.0),
                  child: Text('ปลายทาง'),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips(null),
                    child: const Text('ทั้งหมด'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("เอเชีย"),
                    child: const Text('เอเชีย'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("ยุโรป"),
                    child: const Text('ยุโรป'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("เอเชียตะวันออกเฉียงใต้"),
                    child: const Text('อาเซียน'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("อเมริกาเหนือ"),
                    child: const Text('อเมริกาเหนือ'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("อเมริกาใต้"),
                    child: const Text('อเมริกาใต้'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("แอฟริกา"),
                    child: const Text('แอฟริกา'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("แอนตาร์กติกา"),
                    child: const Text('แอนตาร์กติกา'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilledButton(
                    onPressed: () => getTrips("ประเทศไทย"),
                    child: const Text('ประเทศไทย'),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    //5.call function
                    future: loadData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: trips
                              .map(
                                (trip) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              trip.name,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 95,
                                                  height: 100,
                                                  child: Image.network(
                                                    trip.coverimage,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'ประเทศ ${trip.country}'),
                                                  Text(
                                                      'ระยะเวลา ${trip.duration} วัน'),
                                                  Text(
                                                      'ราคา ${trip.price} บาท'),
                                                  FilledButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TripPage(
                                                                    idx: trip
                                                                        .idx),
                                                          ));
                                                    },
                                                    child: const Text(
                                                        'รายละเอียดเพิ่มเติม'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Card(
                                //   child: Text(trip.name),
                                // ),
                              )
                              .toList(),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  //declare (async) function for loading  data from api

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    var json = await http.get(Uri.parse("$url/trips"));
    trips = tripsGetResponesFromJson(json.body);
  }

  void randomNumbers() async {
    Set<String> uniqueNumbers = Set();

    // สุ่มตัวเลข 6 หลัก 100 ชุดที่ไม่ซ้ำกัน
    while (uniqueNumbers.length < 10) {
      String number = Random().nextInt(999999).toString().padLeft(6, '0');
      uniqueNumbers.add(number);
    }

    // แปลงเป็น List เพื่อใช้งานต่อ
    List<String> numbers = uniqueNumbers.toList();

    // เตรียมข้อมูลสำหรับการส่งไปยังฐานข้อมูลผ่าน API
    var url = Uri.parse(
        'http://192.168.1.8:3004/db/random'); // เปลี่ยน URL ให้ตรงกับ API ที่คุณใช้
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'numbers': numbers});

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Insert success');
      } else {
        print('Failed to insert. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getTrips(String? zone) async {
    // 1. Load url from config
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    // 2. Call Get / trips
    var json = await http.get(Uri.parse("$url/trips"));
    trips = tripsGetResponesFromJson(json.body);
    log('API response body: ${json.body}');

    // 3. Put response data to model
    List<TripsGetRespones> filteredTrips = [];
    // 3.1 Check if zone is "ทั้งหมด" (all)
    if (zone == null) {
      filteredTrips = trips; // Show all trips
    } else {
      for (var trip in trips) {
        String tripZone = destinationZoneValues.reverse[trip.destinationZone]!;
        if (tripZone == zone) {
          filteredTrips.add(trip);
        }
      }
    }

    trips = filteredTrips;

    // 4. Log number of trips
    log(trips.length.toString());
    setState(() {});
  }
}
