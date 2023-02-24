import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group("test user register with google auth", () {
    final instance = FakeFirebaseFirestore();

    test("user registration test", () async {
      const expectedResult = 1;
      await instance.collection('user').add({
        'firstname': 'Bob',
        'lastname': 'Smith',
        'gmail': 'simon@gmail.com',
      });
      final snapshot = await instance.collection('user').get();

      expect(snapshot.docs.length, expectedResult);
      instance.dump();
    });
  });

  test("google auth test", () async {
    var googleSignIn = MockGoogleSignIn();

    final signInAccount = await googleSignIn.signIn();
    final signInAuthentication = await signInAccount!.authentication;
    expect(signInAuthentication, isNotNull);
  });

  test('should return null when google login is cancelled by the user',
      () async {
    var googleSignIn = MockGoogleSignIn();

    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
  });

  test(
      'testing google login twice, once cancelled, once not cancelled at the same test.',
      () async {
    var googleSignIn = MockGoogleSignIn();
    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
    googleSignIn.setIsCancelled(false);
    final signInAccountSecondAttempt = await googleSignIn.signIn();
    expect(signInAccountSecondAttempt, isNotNull);
  });
}
