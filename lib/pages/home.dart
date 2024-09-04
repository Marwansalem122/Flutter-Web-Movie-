import 'package:flutter/material.dart';
import 'package:flutter_web_movie_app/models/movie_model.dart';
import 'package:flutter_web_movie_app/responsive.dart';
import 'package:flutter_web_movie_app/services/movie_services.dart';
import 'package:flutter_web_movie_app/widgets/drawer.dart';
import 'package:flutter_web_movie_app/widgets/footer.dart';
import 'package:flutter_web_movie_app/widgets/home_widgets/custom_carousel_slider.dart';
import 'package:flutter_web_movie_app/widgets/home_widgets/now_playing_list.dart';
import 'package:flutter_web_movie_app/widgets/home_widgets/popular_movies_view.dart';
import 'package:flutter_web_movie_app/widgets/navbar.dart';
import 'package:flutter_web_movie_app/widgets/skeletons/carousel_skeleton.dart';
import 'package:flutter_web_movie_app/widgets/skeletons/now_playing_skelton.dart';
import 'package:flutter_web_movie_app/widgets/skeletons/popular_movies_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    MovieServices movieServices = MovieServices();
    _topRatedMovies = await movieServices.fetchTopRatedMovies();
    _nowPlayingMovies = await movieServices.fetchNowPlayingMovies();
    _popularMovies = await movieServices.fetchPopularMovies();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: const CustomNavbar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Top Rated Movies",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Responsive().isDesktop(context)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: _isLoading
                                    ? const CarouselSkeleton()
                                    : CustomCarouselSlider(
                                        topRatedMovies: _topRatedMovies))),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            flex: 1,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Text(
                                      "Now Playing",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 350,
                                    height: 470,
                                    child: _isLoading
                                        ? const NowPlayingSkelton()
                                        : NowPlayingList(
                                            nowPlayingMovies:
                                                _nowPlayingMovies),
                                  )
                                ]))
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _isLoading
                                ? const CarouselSkeleton()
                                : CustomCarouselSlider(
                                    topRatedMovies: _topRatedMovies)),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "Now Playing",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 350,
                                height: 470,
                                child: _isLoading
                                    ? const NowPlayingSkelton()
                                    : NowPlayingList(
                                        nowPlayingMovies: _nowPlayingMovies),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Explore Popular Movies",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: LayoutBuilder(builder: (context, contraints) {
                  return _isLoading
                      ? const PopularMoviesSkeleton()
                      : MoviesGridView(movies: _popularMovies);
                }),
              ),
              const SizedBox(
                height: 8,
              ),
              Footer()
            ],
          ),
        ));
  }
}
