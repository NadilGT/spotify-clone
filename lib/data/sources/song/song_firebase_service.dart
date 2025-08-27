import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/model/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class SongFirebaseService {
  Future<Either> getNewSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSong(String songId);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();
      print("Songs docs count: ${data.docs.length}");

      for (var element in data.docs) {
        print('Song doc data: ${element.data()}');
        var songModel = SongModel.fromJson(element.data());
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occured, PLease try again');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();
      print("Songs docs count: ${data.docs.length}");

      for (var element in data.docs) {
        print('Song doc data: ${element.data()}');
        var songModel = SongModel.fromJson(element.data());
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occured, PLease try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(String songId) async {

    try{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    late bool isFavorite;
    var user = await firebaseAuth.currentUser;
    String uId = user!.uid;

    QuerySnapshot favoriteSongs = await firebaseFirestore
        .collection('Users')
        .doc(uId)
        .collection('Favorites')
        .where('SongId', isEqualTo: songId)
        .get();

    if (favoriteSongs.docs.isNotEmpty) {
      await favoriteSongs.docs.first.reference.delete();
      isFavorite = false;
    } else {
      await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .add({'songId': songId, 'addedDate': Timestamp.now()});
          isFavorite = true;
    }
    return Right(isFavorite);
    } catch(e) {
      return Left('An error occurred');
    }
  }
}
