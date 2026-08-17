import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favoritesCollection(
      String userId,
      ) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('favorites');
  }

  CollectionReference<Map<String, dynamic>> _listingsCollection(
      String userId,
      ) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('listings');
  }

  DocumentReference<Map<String, dynamic>> _userDocument(
      String userId,
      ) {
    return _db.collection('users').doc(userId);
  }

  Future<void> createUserProfile(
      String userId,
      String email,
      ) async {
    final userDocument = _userDocument(userId);

    final snapshot = await userDocument.get();

    if (!snapshot.exists) {
      await userDocument.set({
        'email': email,
        'name': email.split('@').first,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(
      String userId,
      ) async {
    final snapshot = await _userDocument(userId).get();

    return snapshot.data();
  }

  Future<void> updateUserProfile(
      String userId,
      String name,
      ) async {
    await _userDocument(userId).set(
      {
        'name': name,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> addFavorite(
      String userId,
      String productId,
      ) async {
    await _favoritesCollection(userId)
        .doc(productId)
        .set({
      'productId': productId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(
      String userId,
      String productId,
      ) async {
    await _favoritesCollection(userId)
        .doc(productId)
        .delete();
  }

  Future<Set<String>> getFavoriteIds(
      String userId,
      ) async {
    final snapshot = await _favoritesCollection(userId).get();

    return snapshot.docs
        .map((doc) => doc.id)
        .toSet();
  }

  Future<String> addListing(
      String userId,
      Map<String, dynamic> data,
      ) async {
    final document =
    await _listingsCollection(userId).add(data);

    return document.id;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListings(
      String userId,
      ) async {
    return await _listingsCollection(userId)
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<void> updateListing(
      String userId,
      String listingId,
      Map<String, dynamic> data,
      ) async {
    await _listingsCollection(userId)
        .doc(listingId)
        .update(data);
  }

  Future<void> deleteListing(
      String userId,
      String listingId,
      ) async {
    await _listingsCollection(userId)
        .doc(listingId)
        .delete();
  }
}