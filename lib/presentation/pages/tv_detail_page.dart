import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/media_category.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/presentation/blocs/tv/recommendations_tv/tv_recommendations_bloc.dart';
import 'package:ditonton/presentation/blocs/tv/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        if (!mounted) return;
        context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
        context.read<TvRecommendationsBloc>().add(FetchTvRecommendations(widget.id));
        context.read<WatchlistBloc>().add(LoadWatchlistStatus(widget.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TvDetailLoaded) {
            return SafeArea(
              child: DetailContentTv(state.tvDetail),
            );
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContentTv extends StatelessWidget {
  final TvDetail tv;
  const DetailContentTv(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocListener<WatchlistBloc, WatchlistState>(
                              listenWhen: (previous, current) =>
                                  previous.watchlistMessage != current.watchlistMessage &&
                                  current.watchlistMessage.isNotEmpty,
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message == WatchlistBloc.watchlistAddSuccessMessage ||
                                    message == WatchlistBloc.watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(seconds: 1), content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(message),
                                    ),
                                  );
                                }
                              },
                              child: BlocBuilder<WatchlistBloc, WatchlistState>(
                                builder: (context, state) {
                                  return FilledButton(
                                    onPressed: () async {
                                      if (!state.isAddedtoWatchlist) {
                                        context.read<WatchlistBloc>().add(AddWatchlist(
                                            Watchlist(
                                                id: tv.id,
                                                overview: tv.overview,
                                                posterPath: tv.posterPath,
                                                title: tv.name,
                                                category: MediaCategory.tvSeries.toString()),
                                            tv.id));
                                      } else {
                                        context.read<WatchlistBloc>().add(RemoveFromWatchlist(
                                            Watchlist(
                                                id: tv.id,
                                                overview: tv.overview,
                                                posterPath: tv.posterPath,
                                                title: tv.name,
                                                category: MediaCategory.tvSeries.toString()),
                                            tv.id));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.isAddedtoWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Row(
                              children: [
                                Text(
                                  tv.firstAirDate.substring(0, 4),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text('·'),
                                ),
                                Text(
                                  '${tv.numberOfSeasons.toString()} Season',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text('·'),
                                ),
                                Text(
                                  '${tv.numberOfEpisodes.toString()} Episodes',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview ?? 'No overview available',
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc, TvRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvRecommendationsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationsError) {
                                  return Text(state.message);
                                } else if (state is TvRecommendationsLoaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = state.tv[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.tv.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
