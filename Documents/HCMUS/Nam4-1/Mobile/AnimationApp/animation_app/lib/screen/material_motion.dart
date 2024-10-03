import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../model/movie.dart';

// ignore: must_be_immutable
class MaterialMotionScreen extends StatefulWidget {
  bool useBuiltIn;

  MaterialMotionScreen({super.key, required this.useBuiltIn});

  @override
  State<MaterialMotionScreen> createState() => _MaterialMotionScreenState();
}

class _MaterialMotionScreenState extends State<MaterialMotionScreen> {
  final List<Movie> movies = [
    Movie(
      title: 'The Shawshank Redemption',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_.jpg',
      description:
          'Two imprisoned men forge an unlikely friendship over the years, forming a bond that helps them cope with the harsh realities of prison life.',
      releaseDate: '1994',
    ),
    Movie(
      title: 'The Godfather',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BYTJkNGQyZDgtZDQ0NC00MDM0LWEzZWQtYzUzZDEwMDljZWNjXkEyXkFqcGc@._V1_.jpg',
      description:
          'The Corleone family, a powerful crime dynasty, faces upheaval when the aging patriarch prepares to hand over control to his successor.',
      releaseDate: '1972',
    ),
    Movie(
      title: 'The Godfather: Part II',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BNzc1OWY5MjktZDllMi00ZDEzLWEwMGItYjk1YmRhYjBjNTVlXkEyXkFqcGc@._V1_.jpg',
      description:
          'A continuation of the Corleone family saga, this film explores the rise and fall of Michael Corleone as he becomes the head of the family.',
      releaseDate: '1974',
    ),
    Movie(
      title: 'Schindler\'s List',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BNjM1ZDQxYWUtMzQyZS00MTE1LWJmZGYtNGUyNTdlYjM3ZmVmXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg',
      description:
          'A German businessman saves the lives of hundreds of Jews during the Holocaust by employing them in his factory.',
      releaseDate: '1993',
    ),
    Movie(
      title: '12 Angry Men',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BODQwOTc5MDM2N15BMl5BanBnXkFtZTcwODQxNTEzNA@@._V1_.jpg',
      description:
          'A jury of twelve men must decide the fate of a young man accused of murder, but their deliberations are fraught with tension and prejudice.',
      releaseDate: '1957',
    ),
    Movie(
      title: 'The Dark Knight',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_FMjpg_UX1000_.jpg',
      description:
          'When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness.',
      releaseDate: '2008',
    ),
    Movie(
      title: 'The Good, the Bad and the Ugly',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BMWM5ZjQxM2YtNDlmYi00ZDNhLWI4MWUtN2VkYjBlMTY1ZTkwXkEyXkFqcGc@._V1_.jpg',
      description:
          'A bounty hunting scam joins two men in an uneasy alliance against a third in a race to find a fortune in gold buried in a remote cemetery.',
      releaseDate: '1966',
    ),
    Movie(
      title: 'Forrest Gump',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BNDYwNzVjMTItZmU5YS00YjQ5LTljYjgtMjY2NDVmYWMyNWFmXkEyXkFqcGc@._V1_.jpg',
      description:
          'The history of the United States from the 1950s to the 70s unfolds from the perspective of an Alabama man with an IQ of 75, who yearns to be reunited with his childhood sweetheart.',
      releaseDate: '1994',
    ),
    Movie(
      title: 'Pulp Fiction',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BNGE4MjQ3NjgxOV5BMl5BanBnXkFtZTcwNDc3NTIyNA@@._V1_.jpg',
      description:
          'A series of interconnected stories involving a boxer, a hitman, and a mob boss in Los Angeles.',
      releaseDate: '1994',
    ),
    Movie(
      title: 'Fight Club',
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BMTY2NDc3Nzk3OV5BMl5BanBnXkFtZTcwMTU0NDc3NA@@._V1_.jpg',
      description:
          'An insomniac office worker forms an underground fight club with a charismatic soap salesman.',
      releaseDate: '1999',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Container Transform'),
        ),
        body: widget.useBuiltIn
            ? builtInView(movies, context)
            : libraryView(movies, context));
  }

  Widget builtInView(List<Movie> movies, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Hero(
          tag: movies[index].title,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(movies[index].title,
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: movies[index].title,
                                child: Image.network(movies[index].imageUrl),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Release date: ${movies[index].releaseDate}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                movies[index].description,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(movies[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text(
                        movies[index].description,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget libraryView(List<Movie> movies, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (context, closedContainer) {
            return Scaffold(
              appBar: AppBar(
                title: Text(movies[index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(movies[index].imageUrl),
                      const SizedBox(height: 10),
                      Text(
                        "Release date: ${movies[index].releaseDate}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        movies[index].description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          closedBuilder: (context, openContainer) {
            return GestureDetector(
              onTap: openContainer as GestureTapCallback?,
              child: Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(movies[index].title,
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Text(
                          movies[index].description,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
