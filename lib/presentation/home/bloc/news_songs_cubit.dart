import 'package:dartz/dartz.dart';
import 'package:spotify/domain/usecases/song/get_news_songs.dart';
import 'package:spotify/presentation/home/bloc/news_songs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    var returnedSongs = await sl<GetNewsSongsUseCase>().call();
    print('Returned songs: $returnedSongs');
    returnedSongs.fold(
      (l) {
        emit(NewsSongsLoadFailure());
        print("Failed");
      },
      (data) {
        emit(NewsSongsLoaded(songs: data));
        print("Success: $data");
      },
    );
  }
}
