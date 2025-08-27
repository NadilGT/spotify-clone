import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify/data/model/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class SongFirebaseService {

  Future<Either> getNewSongs();
  Future<Either> getPlayList();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewSongs()async{
    try{
      List<SongEntity> songs = [];
    var data = await FirebaseFirestore.instance.collection('Songs')
    .orderBy('releaseDate', descending: true)
    .get();
    print("Songs docs count: ${data.docs.length}");

    for (var element in data.docs){
      print('Song doc data: ${element.data()}');
      var songModel = SongModel.fromJson(element.data());
      songs.add(
        songModel.toEntity()
      );
    }

    return Right(songs);
    } catch (e){
      return Left('An error occured, PLease try again');
    }
  }
  
  @override
  Future<Either> getPlayList() async {
    try{
      List<SongEntity> songs = [];
    var data = await FirebaseFirestore.instance.collection('Songs')
    .orderBy('releaseDate', descending: true)
    .get();
    print("Songs docs count: ${data.docs.length}");

    for (var element in data.docs){
      print('Song doc data: ${element.data()}');
      var songModel = SongModel.fromJson(element.data());
      songs.add(
        songModel.toEntity()
      );
    }

    return Right(songs);
    } catch (e){
      return Left('An error occured, PLease try again');
    }
  }
}