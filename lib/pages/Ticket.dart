import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_miniproject_app/config/config.dart';
import 'package:mobile_miniproject_app/models/request/cart_post_req.dart';
import 'package:mobile_miniproject_app/models/response/GetCart_Res.dart';
import 'package:mobile_miniproject_app/models/response/GetLotteryNumbers_Res.dart';
import 'package:mobile_miniproject_app/models/response/GetOneUser_Res.dart';
import 'package:mobile_miniproject_app/pages/Home.dart';
import 'package:mobile_miniproject_app/pages/Shop.dart';
import 'package:mobile_miniproject_app/pages/Ticket.dart';
import 'package:mobile_miniproject_app/pages/Profile.dart';
import 'package:mobile_miniproject_app/shared/share_data.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatefulWidget {
  int uid = 0;
  int wallet = 0;
  String username = '';
  int selectedIndex = 0;
  int cart_length = 0;

  TicketPage({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class CartLotteryItem {
  final int lid;
  final List<String> numbers;

  CartLotteryItem({required this.lid, required this.numbers});
}

class _TicketPageState extends State<TicketPage> {
  int uid = 0;
  int wallet = 0;
  String username = '';
  int cart_length = 0;
  GetStorage gs = GetStorage();
  String url = '';
  int Prize = 0;
  List<GetLotteryNumbers> all_Userlotterys = [];
  List<GetLotteryNumbers> all_Winlotterys = [];
  List<GetCartRes> all_cart = [];
  List<CartLotteryItem> cart_lotterys = [];
  List<GetOneUserRes> userInfo = [];
  late Future<void> loadData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    uid = context.read<ShareData>().user_info.uid;
    username = context.read<ShareData>().user_info.username;
    wallet = context.read<ShareData>().user_info.wallet;
    cart_length = context.read<ShareData>().user_info.cart_length;
    _selectedIndex = widget.selectedIndex;
    log(_selectedIndex.toString());
    loadData = loadDataAsync();
    log("CHECKKKKKKKKK length" + all_cart.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black), // สีของข้อความที่เหลือ
                        ),
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight:
                                  FontWeight.bold), // สีของ ${widget.username}
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 1.5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        size: 20,
                        color: Color.fromARGB(255, 254, 137, 69),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Wallet :  ${wallet}  THB',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 131, 130, 130),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return all_Userlotterys.isNotEmpty
                        ? ListView.builder(
                            itemCount: all_Userlotterys.length,
                            itemBuilder: (context, index) {
                              final lottery = all_Userlotterys[index];
                              List<String> numberList =
                                  lottery.numbers.toString().split('');
                              return Card(
                                color: Colors
                                    .transparent, // ทำให้พื้นหลังของ Card เป็นโปร่งใส
                                elevation: 0, // ปิดการแสดงเงา
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // กำหนดความโค้งมนของมุม
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: IntrinsicWidth(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        const Color.fromARGB(
                                                            255, 254, 137, 69),
                                                        Colors.white
                                                            .withOpacity(0),
                                                      ],
                                                      stops: [0.35, 1.0],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 2),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              ...numberList
                                                                  .map(
                                                                    (number) =>
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              3.5,
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          Card(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50.0),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 5.0,
                                                                              vertical: 2),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              number,
                                                                              style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            19.0,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            10),
                                                                child:
                                                                    FilledButton(
                                                                  onPressed:
                                                                      lottery.status_prize >
                                                                              0
                                                                          ? () {
                                                                              int number = int.parse(lottery.numbers);
                                                                              ;
                                                                              List<String> Lot_Num = [
                                                                                number.toString()
                                                                              ];
                                                                              if (lottery.status_prize == 1) {
                                                                                Prize = 10000;
                                                                              } else if (lottery.status_prize == 2) {
                                                                                Prize = 5000;
                                                                              } else if (lottery.status_prize == 3) {
                                                                                Prize = 1000;
                                                                              } else if (lottery.status_prize == 4) {
                                                                                Prize = 500;
                                                                              } else if (lottery.status_prize == 5) {
                                                                                Prize = 150;
                                                                              }
                                                                              log("Prizeeeeeeeeeeeeeeeeee + $Prize");
                                                                              ShowDialog(lottery.lid, Prize);
                                                                            }
                                                                          : null,
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStateProperty
                                                                            .all(
                                                                      lottery.status_prize > 0
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                    foregroundColor:
                                                                        WidgetStateProperty.all(
                                                                            Colors.white),
                                                                    padding:
                                                                        WidgetStateProperty.all<
                                                                            EdgeInsets>(
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              19),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "ขึ้นเงิน",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                'งวดวันที่ : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10.0,
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                () {
                                                                  if (all_Winlotterys
                                                                      .isEmpty) {
                                                                    return "รางวัลยังไม่ออก";
                                                                  } else {
                                                                    if (lottery
                                                                            .status_prize >
                                                                        0) {
                                                                      int prize;
                                                                      switch (lottery
                                                                          .status_prize) {
                                                                        case 1:
                                                                          prize =
                                                                              10000;
                                                                          break;
                                                                        case 2:
                                                                          prize =
                                                                              5000;
                                                                          break;
                                                                        case 3:
                                                                          prize =
                                                                              1000;
                                                                          break;
                                                                        case 4:
                                                                          prize =
                                                                              500;
                                                                          break;
                                                                        case 5:
                                                                          prize =
                                                                              150;
                                                                          break;
                                                                        default:
                                                                          prize =
                                                                              0;
                                                                      }

                                                                      return 'รางวัลที่ ${lottery.status_prize} : $prize บาท';
                                                                    } else {
                                                                      return 'ไม่ถูกรางวัล';
                                                                    }
                                                                  }
                                                                }(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "ไม่มีล็อตเตอรี่ที่ซื้อไว้", // ข้อความที่จะแสดงเมื่อไม่มีค่าใน all_Userlotterys
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          selectedIndex: _selectedIndex,
                        )),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopPage(
                          selectedIndex: _selectedIndex,
                        )),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TicketPage(
                          selectedIndex: _selectedIndex,
                        )),
              );
              break;
            case 3:
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Profile'),
                        onTap: () {
                          Navigator.pop(context); // ปิด BottomSheet ก่อน
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                selectedIndex: _selectedIndex,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          gs.remove('Email'); // ปิด BottomSheet ก่อน
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  );
                },
              );
              break;
          }
        },
        selectedItemColor:
            const Color.fromARGB(255, 250, 150, 44), // สีของไอคอนที่เลือก
        unselectedItemColor: Colors.grey, // สีของไอคอนที่ไม่เลือก
        backgroundColor: Colors.white, // สีพื้นหลังของแถบเมนู
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    var check_prize = await http.get(Uri.parse("$url/db/get_WinLottery"));
    if (check_prize.statusCode == 200) {
      setState(() {
        all_Winlotterys = getLotteryNumbersFromJson(check_prize.body);
      });
      log(all_Winlotterys.toString() + "WINnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
      for (var win_lottery in all_Winlotterys) {
        log(win_lottery.numbers.toString());
      }
    } else {
      log('Failed to load lottery numbers. Status code: ${check_prize.statusCode}');
    }
    ;

    var response = await http.get(Uri.parse("$url/db/get_UserLottery/${uid}"));
    if (response.statusCode == 200) {
      setState(() {
        all_Userlotterys = getLotteryNumbersFromJson(response.body);
      });
      log(all_Userlotterys.toString());
      for (var lottery in all_Userlotterys) {
        log(lottery.numbers.toString());
      }
    } else {
      log('Failed to load lottery numbers. Status code: ${response.statusCode}');
    }

    var get_cart = await http.get(Uri.parse("$url/db/get_cart/${uid}"));
    if (get_cart.statusCode == 200) {
      all_cart = getCartResFromJson(get_cart.body);
      log(all_cart.toString());
      for (var cart in all_cart) {
        log('lid' + cart.cLid.toString());
      }
    } else {
      log('Failed to load lottery numbers. Status code: ${get_cart.statusCode}');
    }
  }

  void ShowDialog(int lid, int Prize) async {
    // var value = await Configuration.getConfig();
    // String url = value['apiEndpoint'];

    // var response = await http.get(Uri.parse("$url/db/get_UserLottery/${uid}"));
    // if (response.statusCode == 200) {
    //   setState(() {
    //     all_Userlotterys = getLotteryNumbersFromJson(response.body);
    //   });
    //   log(all_Userlotterys.toString());
    //   for (var lottery in all_Userlotterys) {
    //     log(lottery.numbers.toString());
    //   }
    // } else {
    //   log('Failed to load lottery numbers. Status code: ${response.statusCode}');
    // }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'ยืนยันที่จะขึ้นเงินหรือไม่',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Text(
          'เงินรางวัลจะถูกเพิ่มไปยังกระเป๋าของท่าน',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                child: FilledButton(
                  onPressed: () {
                    // เรียกใช้ฟังก์ชัน Cash_out และอัปเดตสถานะ
                    Cash_out(lid, Prize);
                    setState(() {});
                    loadDataAsync();
                  },
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(fontSize: 19),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5), // Padding ภายใน
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), // Padding ภายนอก
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(fontSize: 19),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5), // Padding ภายใน
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void Cash_out(int lid, int Prize) async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    log("TEST PRIZEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE" +
        Prize.toString());

    var res = await http.put(
      Uri.parse('$url/db/add_prize/${lid}/${Prize}/${uid}'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
    );

    if (res.statusCode == 200) {
      Get.snackbar(
          'ขึ้นเงินสำเร็จ!!!!!', 'เงินรางวัลจะถูกเพิ่มไปยังกระเป๋าของท่านแล้ว');
      Navigator.pop(context);
      var get_user = await http.get(Uri.parse("$url/db/user/${uid}"));
      if (get_user.statusCode == 200) {
        List<GetOneUserRes> userInfoList = getOneUserResFromJson(get_user.body);
        log("UserInfoooooooooooooooooooooooooo$userInfoList");

        // สมมติว่ามีแค่หนึ่งผู้ใช้ในรายการ
        if (userInfoList.isNotEmpty) {
          GetOneUserRes userInfo = userInfoList.first;
          setState(() {
            wallet =
                context.read<ShareData>().user_info.wallet = userInfo.wallet;
          });
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "ขึ้นเงินไม่สำเร็จ!!!  กรุณาตรวจสอบความถูกต้องอีกครั้ง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: Color.fromARGB(120, 0, 0, 0),
          backgroundColor: Color.fromARGB(255, 244, 0, 0),
          textColor: Colors.white,
          fontSize: 15.0);
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text(
      //       'ขึ้นเงินไม่สำเร็จ',
      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      //     ),
      //     content: Text(
      //       'กรุณาตรวจสอบความถูกต้องอีกครั้ง',
      //       style: TextStyle(fontSize: 15),
      //     ),
      //     actions: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(8.0), // Padding ภายนอก
      //             child: FilledButton(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //                 Navigator.pop(context);
      //               },
      //               child: const Text(
      //                 'ปิด',
      //                 style: TextStyle(fontSize: 19),
      //               ),
      //               style: ButtonStyle(
      //                 backgroundColor: WidgetStateProperty.all(Colors.red),
      //                 padding: WidgetStateProperty.all<EdgeInsets>(
      //                   EdgeInsets.symmetric(
      //                       horizontal: 16.0, vertical: 5), // Padding ภายใน
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // );
    }
  }
}
