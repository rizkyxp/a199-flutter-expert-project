import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/watchlist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  WatchlistMoviesPageState createState() => WatchlistMoviesPageState();
}

class WatchlistMoviesPageState extends State<WatchlistMoviesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistBloc>().add(FetchWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistBloc>().add(FetchWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              if (state is WatchlistLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WatchlistLoaded) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final watchlist = state.watchlist[index];
                    return WatchlistCard(watchlist);
                  },
                  itemCount: state.watchlist.length,
                );
              } else if (state is WatchlistError) {
                return Center(
                  key: Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
