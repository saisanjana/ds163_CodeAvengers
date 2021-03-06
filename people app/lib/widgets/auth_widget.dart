import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protecto/screens/nav_screen.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  _getTab(index, child) {
    return Tab(
      child: SizedBox.expand(
        child: Container(
          alignment: Alignment.center,
          child: child,
          decoration: BoxDecoration(
            color: (_selectedTab == index ? Colors.green : Colors.grey.shade50),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
          ),
        ),
      ),
    );
  }

  void login(email, password) async {
    final user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
  }

  void signup(email, password, name) async {
    final user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      print(e.toString());
      return;
    });
    await Firestore.instance
        .collection('users')
        .document(user.user.uid)
        .setData({
      'name': name,
      'email': email,
      'uid': user.user.uid,
    });
    print("Done");
    user.user.sendEmailVerification();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Material(
            //color: Colors.grey.shade300,
            child: TabBar(
              //unselectedLabelColor: Colors.blue,
              labelColor: Colors.black,
              indicatorColor: Colors.green,
              controller: _tabController,
              labelPadding: const EdgeInsets.all(0),
              tabs: <Widget>[
                _getTab(0, Text("Login")),
                _getTab(1, Text("Signup")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListTile(
                            leading: ImageIcon(
                              AssetImage("assets/images/mail_icon.png"),
                              color: Colors.white,
                              size: 40,
                            ),
                            title: TextField(
                              controller: email,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Colors.white70, fontSize: 19),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          //padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListTile(
                            leading: ImageIcon(
                              AssetImage("assets/images/password_icon.png"),
                              color: Colors.white,
                              size: 35,
                            ),
                            title: TextField(
                              controller: password,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.white70, fontSize: 19),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            login(email.text, password.text);
                          },
                          child: Image.asset("assets/images/login_button.png"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/mail_icon.png"),
                            color: Colors.white,
                            size: 40,
                          ),
                          title: TextField(
                            controller: email,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Colors.white70, fontSize: 19),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/user_icon.png"),
                            color: Colors.white,
                            size: 40,
                          ),
                          title: TextField(
                            controller: name,
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.white70, fontSize: 19),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        //padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/password_icon.png"),
                            color: Colors.white,
                            size: 35,
                          ),
                          title: TextField(
                            controller: password,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.white70, fontSize: 19),
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        //padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/password_icon.png"),
                            color: Colors.white,
                            size: 35,
                          ),
                          title: TextField(
                            controller: confirm,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                  color: Colors.white70, fontSize: 19),
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          signup(email.text, password.text, name.text);
                        },
                        child: Image.asset("assets/images/signup_button.png"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
