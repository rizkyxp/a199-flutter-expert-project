import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie/now_playing_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const routeName = '/now-playing-movie';

  const NowPlayingMoviesPage({Key? key}) : super(key: key);

  @override
  NowPlayingMoviesPageState createState() => NowPlayingMoviesPageState();
}

class NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<NowPlayingMoviesNotifier>(context, listen: false).fetchNowPlayingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingMoviesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.movies[index];
                  return MovieCard(movie);
                },
                itemCount: data.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
