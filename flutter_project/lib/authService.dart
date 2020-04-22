import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_project/api.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final APIService _apiService = APIService();

  User _convertFirebaseUserToUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  RegisteredUser _convertToRegisteredUser(Map<String, dynamic> data) {
    var reference = Firestore.instance.collection('users').reference();
    try {
      if (data != null) {
        RegisteredUser new_user = RegisteredUser.registerUser(data: data);
        reference.add(data);
        return new_user;
      }
      else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInAnom() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  // creating a stream for detecting auth states
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_convertFirebaseUserToUser);
  }

  //  register with email and passwordz
  Future registerWithEmailAndPassword(String email, String password, Map<String, dynamic> data) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      User custom_user = _convertFirebaseUserToUser(user);
      data['uid'] = custom_user.uid;

      return _apiService.registerUser(data);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //  signIn with email and passwordz
  Future signInWithEmailAndPassword(String email, String password) async {
    final snapshots = Firestore.instance.collection('users').snapshots();
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
//      DocumentSnapshot snapshot = snapshots
      return _convertFirebaseUserToUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//  sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}