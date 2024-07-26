import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 앱 시작 시 항상 로그아웃 처리
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(
          '같이TA',
          style: TextStyle(
            fontSize: 50,
            fontFamily: 'WAGURI',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/symbol.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            const Text(
              '로그인을 해주세요!',
              style: TextStyle(
                fontSize: 23,
                fontFamily: 'WAGURI',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 65),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'WAGURI',
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),
            Text(
              'made by Software',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'WAGURI',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(
          '로그인',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'WAGURI',
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                labelStyle: TextStyle(
                  fontFamily: 'WAGURI',
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(
                  fontFamily: 'WAGURI',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  _showSuccessPopup(context, "로그인 성공!");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    _showErrorPopup(context, "사용자를 찾을 수 없습니다.");
                  } else if (e.code == 'wrong-password') {
                    _showErrorPopup(context, "잘못된 비밀번호입니다.");
                  } else {
                    _showErrorPopup(context, "로그인에 실패했습니다.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 65),
                textStyle: TextStyle(
                  fontSize: 22,
                  fontFamily: 'WAGURI',
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  '로그인',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 80),
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'WAGURI',
            ),
          ),
        );
      },
    );
  }

  void _showSuccessPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NewMainScreen()),
                (route) => false,
          );
        });
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 80),
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'WAGURI',
            ),
          ),
        );
      },
    );
  }
}

class NewMainScreen extends StatefulWidget {
  const NewMainScreen({Key? key}) : super(key: key);

  @override
  _NewMainScreenState createState() => _NewMainScreenState();
}

class _NewMainScreenState extends State<NewMainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToMileageRechargeScreen(int currentMileage) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MileageRechargeScreen(currentMileage: currentMileage),
      ),
    );
  }

  void _navigateToRoomListScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('경로 안내',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'WAGURI',
          ),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('출발지 : 장전역 4번 출구',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'WAGURI',
                color: Colors.orange,
              ),),
            SizedBox(height: 8),
            Text('도착지 : 부산가톨릭대학교 정문',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'WAGURI',
                color: Colors.orange,
              ),),
            SizedBox(height: 10),
            Text('출발지와 도착지가 정해져있습니다.',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'WAGURI',
              ),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'WAGURI',
              ),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomListScreen()),
              );
            },
            child: Text('확인',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'WAGURI',
              ),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          backgroundColor: Color(0xFFFFFFFF),
          title: Text(
            '같이TA',
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'WAGURI',
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            int currentMileage = userData['mileage'] ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => _navigateToMileageRechargeScreen(currentMileage),
                        icon: Icon(Icons.monetization_on),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '마일리지: $currentMileage',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'WAGURI',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/symbol.png',
                          width: 300,
                          height: 300,
                        ),
                        SizedBox(height: 20),
                        if (currentMileage >= 3500) // 마일리지가 충분한지 확인
                          const Text(
                            '방을 찾아보세요!',
                            style: TextStyle(
                              fontSize: 23,
                              fontFamily: 'WAGURI',
                            ),
                          ),
                        SizedBox(height: 20),
                        if (currentMileage >= 3500) // 마일리지 조건 확인
                          ElevatedButton(
                            onPressed: _navigateToRoomListScreen,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 65),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: const Text(
                                '방 찾기!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'WAGURI',
                                ),
                              ),
                            ),
                          ),
                        if (currentMileage < 3500) // 마일리지가 부족할 때 메시지 표시
                          Column(
                            children: [
                              Text(
                                '마일리지가 부족하여 매칭을 시작할 수 없습니다.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontFamily: 'WAGURI',
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\$',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontFamily: 'WAGURI',
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' 를 눌러 마일리지를 충전하세요.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontFamily: 'WAGURI',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '(최소 3500이상 필요)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontFamily: 'WAGURI',
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 150),
                        Text(
                          'made by Software',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'WAGURI',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final CollectionReference roomsCollection =
  FirebaseFirestore.instance.collection('rooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          '방 목록',
          style: TextStyle(
            fontFamily: 'WAGURI',
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: roomsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot room = snapshot.data!.docs[index];
              return ListTile(
                title: Text(room['title'],
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'WAGURI',
                  ),
                ),
                subtitle: Text('참가자: ${room['users'].length}/4',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'WAGURI',
                  ),),
                onTap: () {
                  _joinRoom(room.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createRoom,
        child: Icon(Icons.add),
      ),
    );
  }

  void _createRoom() {
    TextEditingController roomTitleController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('방 생성',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'WAGURI',
            ),),
          content: TextField(
            controller: roomTitleController,
            decoration: InputDecoration(hintText: "방 제목",
            hintStyle: TextStyle(
              fontSize: 17,
              fontFamily: 'WAGURI',
            ),),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'WAGURI',
                ),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  DocumentReference roomRef = await roomsCollection.add({
                    'title': roomTitleController.text,
                    'users': [user.uid],
                    'creatorUid': user.uid,
                    'settle': false,
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoomScreen(roomId: roomRef.id)),
                  );
                }
              },
              child: Text('확인',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'WAGURI',
                ),),
            ),
          ],
        );
      },
    );
  }

  void _joinRoom(String roomId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentReference roomRef = roomsCollection.doc(roomId);
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      List<dynamic> users = List.from(roomSnapshot['users']);
      if (!users.contains(user.uid) && users.length < 4) {
        users.add(user.uid);
        await roomRef.update({'users': users});
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomScreen(roomId: roomId)),
      );
    } else {
      // 에러 처리: 방이 존재하지 않음
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('방이 존재하지 않습니다.')));
    }
  }
}

class RoomScreen extends StatefulWidget {
  final String roomId;

  RoomScreen({required this.roomId});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late DocumentReference roomRef;
  late StreamSubscription<DocumentSnapshot> _roomSubscription;
  late String creatorUid;
  List<dynamic> users = [];
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);
    _roomSubscription = roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          creatorUid = snapshot['creatorUid'];
          users = List.from(snapshot['users']);
          if (snapshot['settle']) {
            _navigateToSettlementScreen();
          } else {
            _fetchUserNames();
          }
        });
      } else {
        // 방이 삭제된 경우 모든 사용자를 방 목록으로 이동
        Navigator.pop(context);
      }
    });
  }

  Future<void> _fetchUserNames() async {
    for (String userId in users) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          userNames[userId] = userDoc['name'];
        });
      }
    }
  }

  @override
  void dispose() {
    _roomSubscription.cancel();
    super.dispose();
  }

  void _leaveRoom() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      if (creatorUid == user.uid) {
        await roomRef.delete();
        for (String userId in users) {
          if (userId != user.uid) {
            DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
            await userRef.update({
              'leaveRoom': true,
            });
          }
        }
      } else {
        users.remove(user.uid);
        await roomRef.update({'users': users});
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RoomListScreen()),
    );
  }

  void _settleCosts() async {
    await _fetchUserNames(); // 유저 이름을 먼저 가져옴
    await roomRef.update({'settle': true});
    _navigateToSettlementScreen();
  }

  void _navigateToSettlementScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (creatorUid == user.uid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettlementConfirmationScreen(roomRef: roomRef)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentInstructionScreen(roomRef: roomRef)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 뒤로가기 버튼 비활성화
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            '방',
            style: TextStyle(
              fontFamily: 'WAGURI',
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    bool isCreator = users[index] == creatorUid;
                    return ListTile(
                      title: Text(
                        userNames[users[index]] ?? 'Loading...',
                        style: TextStyle(
                          fontFamily: 'WAGURI',
                          fontSize: 25, // 크게 표시
                          fontWeight: isCreator ? FontWeight.bold : FontWeight.normal,
                          color: isCreator ? Colors.blue : Colors.black,
                        ),
                      ),
                      leading: isCreator ? Icon(Icons.star, color: Colors.blue) : null,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (creatorUid == FirebaseAuth.instance.currentUser!.uid)
                ElevatedButton(
                  onPressed: _settleCosts,
                  child: Text('정산하기',
                      style: TextStyle(
                        fontFamily: 'WAGURI',
                        fontSize: 20,)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _leaveRoom,
                child: Text('방에서 나가기',
                    style: TextStyle(
                      fontFamily: 'WAGURI',
                      fontSize: 20,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

class SettlementConfirmationScreen extends StatefulWidget {
  final DocumentReference roomRef;

  SettlementConfirmationScreen({required this.roomRef});

  @override
  _SettlementConfirmationScreenState createState() => _SettlementConfirmationScreenState();
}

class _SettlementConfirmationScreenState extends State<SettlementConfirmationScreen> {
  Map<String, bool> userPayments = {};
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchUserNames();
  }

  Future<void> _fetchUserNames() async {
    try {
      DocumentSnapshot roomSnapshot = await widget.roomRef.get();
      Map<String, dynamic>? roomData = roomSnapshot.data() as Map<String, dynamic>?;
      if (roomData == null) {
        print('Error: Room data is null');
        return;
      }
      List<dynamic> users = List.from(roomData['users']);

      for (String userId in users) {
        if (userId == roomData['creatorUid']) {
          continue; // 방장 제외
        }

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String name = userDoc['name'];

        setState(() {
          userNames[userId] = name;
        });

        // Debug: Print fetched user name
        print('User: $name');
      }
    } catch (e) {
      // Debug: Print error if data fetch fails
      print('Error fetching user names: $e');
    }
  }

  Future<void> _confirmPayments() async {
    bool confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '확인',
            style: TextStyle(
              fontFamily: 'WAGURI',
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정말 모든 사용자들이 송금했는지',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 15,
                ),
              ),
              Text(
                '확인하셨습니까?',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  color: Colors.red,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 취소
              },
              child: Text(
                '취소',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 확인
              },
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirm) {
      try {
        await widget.roomRef.delete(); // 방 삭제
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RoomListScreen()),
              (Route<dynamic> route) => false,
        ); // 방 목록으로 이동 후 뒤로가기 비활성화
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('방을 삭제하는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '정산 확인',
          style: TextStyle(
            fontFamily: 'WAGURI',
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: widget.roomRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic>? roomData = snapshot.data!.data() as Map<String, dynamic>?;
          if (roomData == null) {
            return Center(child: Text('Room data is null'));
          }

          List<dynamic> users = List.from(roomData['users']);
          Map<String, dynamic> payments = roomData.containsKey('payments') ? roomData['payments'] : {};

          for (String userId in users) {
            if (userId == roomData['creatorUid']) {
              continue; // 방장 제외
            }

            bool hasPaid = payments[userId] ?? false;
            userPayments[userId] = hasPaid;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '다른 사용자들이 송금했는지 확인합니다.',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'WAGURI',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                for (String userId in userNames.keys)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userNames[userId]}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'WAGURI',
                        ),
                      ),
                      Icon(
                        userPayments[userId] == true ? Icons.check_circle : Icons.cancel,
                        color: userPayments[userId] == true ? Colors.green : Colors.red,
                        size: 30.0, // Make the icons larger
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _confirmPayments,
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'WAGURI',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentInstructionScreen extends StatefulWidget {
  final DocumentReference roomRef;

  PaymentInstructionScreen({required this.roomRef});

  @override
  _PaymentInstructionScreenState createState() => _PaymentInstructionScreenState();
}

class _PaymentInstructionScreenState extends State<PaymentInstructionScreen> {
  int individualCost = 0;
  int userMileage = 0;
  bool canPay = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _listenForSettlement();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot roomSnapshot = await widget.roomRef.get();
    List<dynamic> users = List.from(roomSnapshot['users']);
    int totalMileage = 6240;
    individualCost = (totalMileage / users.length).toInt();

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      userMileage = userDoc['mileage'];
      setState(() {
        canPay = userMileage >= individualCost;
      });
    }
  }

  void _listenForSettlement() {
    widget.roomRef.snapshots().listen((snapshot) {
      if (!snapshot.exists) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RoomListScreen()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  void _showPaymentConfirmation() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      int newMileage = userMileage - individualCost;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '송금 확인',
              style: TextStyle(
                fontFamily: 'WAGURI',
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '현재 마일리지: ${NumberFormat('#,###').format(userMileage)}',
                  style: TextStyle(
                    fontFamily: 'WAGURI',
                    fontSize: 15,
                  ),
                ),
                Text(
                  '송금 후 마일리지: ${NumberFormat('#,###').format(newMileage)}',
                  style: TextStyle(
                    fontFamily: 'WAGURI',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 취소
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontFamily: 'WAGURI',
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  _makePayment();
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontFamily: 'WAGURI',
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _makePayment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && canPay) {
      // 방장의 uid를 가져오기 위해 방 문서를 읽음
      DocumentSnapshot roomSnapshot = await widget.roomRef.get();
      String creatorUid = roomSnapshot['creatorUid'];

      // 방장의 mileage 증가
      DocumentReference creatorRef = FirebaseFirestore.instance.collection('users').doc(creatorUid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot creatorSnapshot = await transaction.get(creatorRef);
        int newMileage = creatorSnapshot['mileage'] + individualCost;
        transaction.update(creatorRef, {'mileage': newMileage});
      });

      // 사용자의 mileage 감소
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'mileage': FieldValue.increment(-individualCost)
      });

      // 방의 payments 업데이트
      await widget.roomRef.update({
        'payments.${user.uid}': true
      });

      setState(() {
        userMileage -= individualCost;
        canPay = userMileage >= individualCost;
      });

      _showWaitingMessage();
    }
  }

  void _showWaitingMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '송금 완료',
            style: TextStyle(
              fontFamily: 'WAGURI',
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '송금이 완료되었습니다.',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '방장이 정산중입니다...',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '송금 안내',
          style: TextStyle(
            fontFamily: 'WAGURI',
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '방장에게 마일리지를 송금하세요.',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'WAGURI',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '각자 내야할 금액: ${NumberFormat('#,###').format(individualCost)}원',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'WAGURI',
              ),
            ),
            SizedBox(height: 20),
            if (canPay)
              ElevatedButton(
                onPressed: _showPaymentConfirmation,
                child: Text(
                  '송금하기',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'WAGURI',
                  ),
                ),
              )
            else
              Text(
                '잔액이 부족합니다.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class MileageRechargeScreen extends StatefulWidget {
  final int currentMileage;

  MileageRechargeScreen({Key? key, required this.currentMileage}) : super(key: key);

  @override
  _MileageRechargeScreenState createState() => _MileageRechargeScreenState();
}

class _MileageRechargeScreenState extends State<MileageRechargeScreen> {
  late int currentMileage; // 초기값 설정
  String selectedAmount = '2000'; // 기본 선택 금액
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentMileage = widget.currentMileage; // widget의 currentMileage를 초기화
    _fetchCurrentMileage();
  }

  Future<void> _fetchCurrentMileage() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            currentMileage = userDoc['mileage'] ?? 0;
          });
        }
      }
    } catch (e) {
      print("Failed to fetch mileage: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToPaymentScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(selectedAmount: selectedAmount),
      ),
    );
    // MileageRechargeScreen으로 돌아온 후 마일리지 업데이트
    await _fetchCurrentMileage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '마일리지 충전',
          style: TextStyle(
            fontFamily: 'WAGURI', // 원하는 폰트 패밀리로 변경
            fontSize: 30, // 필요에 따라 폰트 크기 조정
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedAmount,
              onChanged: (String? value) {
                setState(() {
                  selectedAmount = value!;
                });
              },
              items: <String>['2000', '5000', '10000', '50000']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value 마일리지'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              '충전 후 총 마일리지: ${currentMileage + int.parse(selectedAmount)}', // currentMileage 사용
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'WAGURI',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToPaymentScreen,
              child: Text(
                '충전하기',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String selectedAmount;

  const PaymentScreen({Key? key, required this.selectedAmount}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late int currentMileage;
  late String cardNumber;
  late String expirationMonth;
  late String expirationYear;
  late String cvc;
  late String cardPassword;
  bool isProcessing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentMileage();
  }

  Future<void> _fetchCurrentMileage() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            currentMileage = userDoc['mileage'] ?? 0;
          });
        }
      }
    } catch (e) {
      print("Failed to fetch mileage: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '마일리지 결제',
          style: TextStyle(
            fontFamily: 'WAGURI',
            fontSize: 30,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '카드 번호',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardNumberTextField(),
                SizedBox(width: 10),
                _buildCardNumberTextField(),
                SizedBox(width: 10),
                _buildCardNumberTextField(),
                SizedBox(width: 10),
                _buildCardNumberTextField(isLast: true),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 50, // 필요한 대로 폭 조정
                  child: _buildExpirationDateTextField('MM'),
                ),
                SizedBox(width: 10),
                Container(
                  width: 50, // 필요한 대로 폭 조정
                  child: _buildExpirationDateTextField('YY'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'CVC'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3), // CVC는 최대 3자리
              ],
              onChanged: (value) {
                setState(() {
                  cvc = value; // 현재 입력된 값을 사용
                });
              },
              obscureText: true, // 입력 내용을 숨김
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: '카드 비밀번호 앞 2자리'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2), // 카드 비밀번호 앞 2자리
              ],
              onChanged: (value) {
                setState(() {
                  cardPassword = value; // 현재 입력된 값을 사용
                });
              },
              obscureText: true, // 입력 내용을 숨김
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing ? null : _processPayment,
              child: isProcessing
                  ? CircularProgressIndicator()
                  : Text(
                '결제하기',
                style: TextStyle(
                  fontFamily: 'WAGURI',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumberTextField({bool isLast = false}) {
    return Expanded(
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onChanged: (value) {
          if (isLast && value.length == 4) {
            FocusScope.of(context).unfocus(); // 마지막 필드가 채워지면 포커스 제거
          }
        },
        obscureText: isLast, // 마지막 필드를 숨김
      ),
    );
  }

  Widget _buildExpirationDateTextField(String label) {
    return Container(
      width: 50, // 조정 가능한 필드 폭
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        onChanged: (value) {
          if (label == 'MM') {
            setState(() {
              expirationMonth = value;
            });
          } else if (label == 'YY') {
            setState(() {
              expirationYear = value;
            });
          }
        },
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    // 결제 처리 시뮬레이션 (1초 대기)
    await Future.delayed(Duration(seconds: 1));

    // 실제 결제 처리 로직으로 대체
    User? user = _auth.currentUser;
    if (user != null) {
      int newMileage = currentMileage + int.parse(widget.selectedAmount);
      await _firestore.collection('users').doc(user.uid).update({
        'mileage': newMileage,
      });

      // 결제 완료 후 팝업 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("결제 완료",
              style: TextStyle(
                fontFamily: 'WAGURI',
                fontSize: 20,
              ),),
            content: Text("마일리지가 충전되었습니다.",
              style: TextStyle(
                fontFamily: 'WAGURI',
                fontSize: 17,
              ),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => NewMainScreen()),
                        (route) => false,
                  );
                },
                child: Text("확인",
                  style: TextStyle(
                    fontFamily: 'WAGURI',
                    fontSize: 15,
                  ),),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isProcessing = false;
    });
  }
}