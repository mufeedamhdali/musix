import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/song_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Song> songs = [];

  HomeBloc() : super(HomeInitial()) {
    on<LoadDataEvent>((event, emit) async {
      try {
        CollectionReference collectionRef = db.collection('songs');
        QuerySnapshot querySnapshot = await collectionRef.get();
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        // print(allData.first.runtimeType);
        for (var item in allData) {
          Song temp = Song(
            name: (item as dynamic)['name'] ?? "",
            link: (item as dynamic)['link'] ?? "",
            id: (item as dynamic)['id'] ?? "",
            artist: (item as dynamic)['artist'] ?? "",
            coverUrl: (item as dynamic)['cover'] ?? "",
            isFavorite: (item as dynamic)['isFavorite'] ?? "",
          );
          songs.add(temp);
        }
      } catch (e) {
        emit(HomeLoadingError(message: e.toString()));
      }
    });

    on<UpdateFavoriteEvent>((event, emit) async {
      try {
        var collection = FirebaseFirestore.instance.collection('songs');
        collection
            .doc(event.docId)
            .update({'isFavorite': event.value}) // <-- Updated data
            .then((_) => print('Success'))
            .catchError((error) => print('Failed: $error'));
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
