import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:musix/application/Home/bloc/home_bloc.dart';
import 'package:musix/utils/constants.dart';
import 'package:musix/utils/images.dart';
import 'package:musix/widgets/custom_loading_indicator.dart';
import 'package:musix/widgets/hero_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_text_form_field.dart';
import '../../Details/view/details_screen.dart';
import '../../Theme/theme_bloc.dart';
import '../model/song_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();
  String searchedQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: appBarTitle(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * .55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(Images.trendingCover),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20)),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Animate(
                delay: Duration(seconds: 1),
                effects: [FadeEffect(), ScaleEffect()],
                child: const Text(
                  "Discover!",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                ),
              ),
            ),
            CustomTextFormField(
              onChanged: (value) {
                setState(() {
                  searchedQuery = value;
                });
              },
              controller: searchController,
              textCapitalization: TextCapitalization.words,
              hintText: "Search",
              marginHorizontal: 10,
              paddingHorizontal: 0,
              suffixIcon: IconButton(
                icon: Image.asset(
                  Images.searchIcon,
                  width: 26,
                  height: 26,
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    searchedQuery = searchController.text.trim();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('songs')
                    .where("name", isGreaterThanOrEqualTo: searchedQuery)
                    .where("name", isLessThanOrEqualTo: "$searchedQuery\uf7ff")
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      streamSnapshot.hasData != true) {
                    return const CustomLoadingIndicator();
                  }
                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 44.0,
                            child: FadeInAnimation(
                              child: musicTile(
                                  index: index,
                                  map: streamSnapshot.data!.docs[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                  return ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              musicTile(
                                  index: index,
                                  map: streamSnapshot.data!.docs[index]),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 0),
          child: Center(
              child: Image.asset(
            Images.logo,
            height: 50,
            width: 50,
          )),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 20, right: 0, left: 20),
          child: Row(
            children: [
              BlocBuilder<ThemeBloc, ThemeData>(
                builder: (context, themeData) {
                  return CupertinoSwitch(
                      activeColor: Theme.of(context).primaryColorDark,
                      value: themeData == darkTheme,
                      onChanged: (bool val) {
                        BlocProvider.of<ThemeBloc>(context)
                            .add(ThemeSwitchEvent());
                      });
                },
              ),
              GestureDetector(
                onTap: () {
                  showPopupMenu(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    Images.menuIcon,
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget musicTile({required int index, map}) {
    Song song = Song(
      name: map['name'] ?? "",
      link: map['link'] ?? "",
      id: map['id'] ?? "",
      artist: map['artist'] ?? "",
      coverUrl: map['cover'] ?? "",
      isFavorite: map['isFavorite'] ?? "",
    );
    return GestureDetector(
      onTap: () {
        _gotoDetailsPage(context, song, "hero-rectangle$index");
      },
      child: Container(
        // height: 80,
        margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
        padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: primaryDark,
          // ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 16),
              blurRadius: 25,
              color: Theme.of(context).shadowColor,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Hero(
                  tag: 'hero-rectangle$index',
                  child: HeroBoxWidget(
                    size: const Size(60, 60),
                    link: song.coverUrl,
                    radius: 5,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8),
                //       image: DecorationImage(
                //           fit: BoxFit.fill,
                //           image: NetworkImage(
                //               song.coverUrl))),
                //   height: 60,
                //   width: 60,
                // ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: 'Roboto'),
                    ),
                    Text(
                      song.artist,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: 'Roboto'),
                    )
                  ],
                ),
              ],
            ),
            InkResponse(
              onTap: () {
                final homeBloc = BlocProvider.of<HomeBloc>(context);
                homeBloc.add(UpdateFavoriteEvent(
                    docId: song.id.toString(), value: !song.isFavorite));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: song.isFavorite
                    ? Icon(
                        Icons.favorite_rounded,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(
                        Icons.favorite_border_rounded,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
              ),
            )
            // const Gap(5),
          ],
        ),
      ),
    );
  }

  void _gotoDetailsPage(BuildContext context, Song song, String tag) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => DetailsScreen(song: song, tag: tag),
    ));
  }

  showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      useRootNavigator: true,
      position:
          RelativeRect.fromLTRB(MediaQuery.of(context).size.width, 0, 0, 0),
      items: [
        PopupMenuItem<String>(
          value: 'Log out',
          onTap: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            // final authBoc = BlocProvider.of<AuthBloc>(context);
            // authBoc.add(LogoutEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
          child: const Text('Log out'),
        ),
      ],
      elevation: 8.0,
    );
  }
}
