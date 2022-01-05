import "dart:math" show pi;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';

import '../coin/bitexen/view/bitexen_page.dart';
import '../coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import '../coin/hurriyet/view/hurriyet_page.dart';
import '../coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import '../coin/list_all_coin_page/view/coin_list_page.dart';
import '../coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import '../coin/selected_coin/view/selected_coin_page.dart';
import '../coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import '../coin/truncgil/view/truncgil_page.dart';
import '../coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

Widget aastream() {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
    stream: _usersStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['full_name']),
            subtitle: Text(data['age']),
          );
        }).toList(),
      );
    },
  ));
}

Widget aa() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return SafeArea(
    child: FutureBuilder<DocumentSnapshot>(
      future: users.doc().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['age']}");
        }

        return Text("loading");
      },
    ),
  );
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;

  List listPage = [
    SelectedCoinPage(),
    CoinListPage(),
    BitexenPage(),
    TruncgilPage(),
    // aa(),
    HurriyetPage(),
  ];

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    //auth.authStateChanges().listen((User? user) {
    //  if (user == null) {
    //    print('User is currently signed out!');
    //  } else {
    //    print('User is signed in!');
    //  }
    //});

    _tabController = TabController(length: listPage.length, vsync: this);
    print("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      print("SchedulerBinding");
    });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (context.read<ListPageGeneralCubit>().textEditingController != null) {
      context.read<ListPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<SelectedPageGeneralCubit>().textEditingController !=
        null) {
      context.read<SelectedPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<BitexenPageGeneralCubit>().textEditingController != null) {
      context.read<BitexenPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context
            .read<HurriyetPageGeneralStateDartCubit>()
            .textEditingController !=
        null) {
      context
          .read<HurriyetPageGeneralStateDartCubit>()
          .closeKeyBoardAndUnFocus();
    }
    if (context.read<TruncgilPageGeneralCubit>().textEditingController !=
        null) {
      context.read<TruncgilPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    setState(() {
      print("aaaaaaaaaa");
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  _tabBarView() {
    return AnimatedBuilder(
      animation: (_tabController.animation as Animation<double>),
      builder: (BuildContext context, snapshot) {
        return Transform.rotate(
          angle: _tabController.animation!.value * pi,
          child: [
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.lightGreen,
            ),
            Container(
              color: Colors.red,
            ),
          ][_tabController.animation!.value.round()],
        );
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> adduser2() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .add({
          'full_name': "fullName", // John Doe
          'company': "company", // Stokes and Sons
          'age': "age" // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> readaa() async {
    FirebaseFirestore.instance
        .collection('users')
        .where(
          "age",
        )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["full_name"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //floatingActionButton: Column(
        //  mainAxisAlignment: MainAxisAlignment.end,
        //  children: [
        //    FloatingActionButton(
        //      heroTag: "a",
        //      onPressed: () async {
        //        try {
        //          await auth.createUserWithEmailAndPassword(
        //              email: "facar@gmail.com", password: "123123");
        //          await signInWithGoogle();
        //          adduser2();
        //        } catch (e) {
        //          print(e);
        //        }
        //      },
        //      child: Icon(Icons.add),
        //    ),
        //    FloatingActionButton(
        //      heroTag: "b",
        //      onPressed: () async {
        //        await auth.signInWithEmailAndPassword(
        //            email: "facar@gmail.com", password: "123123");
        //        //await readaa();
        //      },
        //      child: Icon(Icons.multiline_chart),
        //    ),
        //    FloatingActionButton(
        //      heroTag: "c",
        //      onPressed: () {
        //        AppCacheManager _cacheManager = locator<AppCacheManager>();

        //        _cacheManager.putBoolItem(
        //            PreferencesKeys.IS_FIRST_APP.name, false);
        //        // auth.signOut();
        //      },
        //      child: Icon(Icons.remove),
        //    )
        //  ],
        //),
        extendBody: true,
        body: listPage[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            color: Theme.of(context).colorScheme.onPrimary,
            buttonBackgroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 450),
            //color: Theme.of(context).colorScheme.secondaryVariant,
            onTap: _onItemTapped,
            items: [
              Icon(
                Icons.home,
                color: tabbarLabelColorGenerator(0),
              ),
              SizedBox(
                height: 35,
                child: Image.asset(
                  "assets/icon/btcIcon.png",
                  color: tabbarLabelColorGenerator(1),
                ),
              ),
              Center(
                child: Icon(
                  Icons.sports_football,
                  color: tabbarLabelColorGenerator(2),
                ),
              ),
              Icon(
                Icons.attach_money,
                color: tabbarLabelColorGenerator(3),
              ),
              //Icon(
              //  Icons.search,
              //  color: tabbarLabelColorGenerator(3),
              //),

              Icon(
                Icons.money,
                color: tabbarLabelColorGenerator(4),
              ),
            ]),
      ),
    );
  }

  Color tabbarLabelColorGenerator(int index) {
    if (_selectedIndex == index) {
      return Theme.of(context).colorScheme.background;
    } else {
      return Theme.of(context).tabBarTheme.unselectedLabelColor ??
          Theme.of(context).colorScheme.primary;
    }
  }
}

/**
 * 
 *  BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab1.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab2.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab3.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab4.locale)
 */

/**

DotNavigationBar(
          backgroundColor: Colors.grey[100],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey[500],
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.details),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.settings),
            )
          ])

 */