class AppConstants {
  // Colors
  static const int primaryColorHex = 0xFF1DB584;
  static const int orangeColorHex = 0xFFFF9500;
  static const int darkColorHex = 0xFF2C3E50;
  static const int lightGrayHex = 0xFFF8F9FA;

  // base url
  static const String baseURl= 'http://localhost:8082';
  // album end-point
  static const String albumsEndpoint = '/albums';
  static const String albumsCercaArtistaNome= '$albumsEndpoint/search/by_artist_and_name';
  static const String albumsPiuVotati= '$albumsEndpoint/most_voted/by_avg';
  static const String albumsGetByGeneri= '$albumsEndpoint/search/by_generi';
  static const String albumsPiuVotatiPerGenere= '$albumsEndpoint/most_voted/by_genre';
  static const String albumsGetByID= '$albumsEndpoint/search/byId';
  static const String albumsGetAll= '$albumsEndpoint/paged';
  static const String albumsGetByArtista= '$albumsEndpoint/search/by_artist';

  // artista end-point
  static const String artistsEndpoint= '/artists';
  static const String artistsCercaPerNome= '$artistsEndpoint/search/by_name';
  static const String artistsMostPopular= '$artistsEndpoint/most_popular';
  static const String artistsPopularByGenre= '$artistsEndpoint/popular/by_genre';
  static const String artistsSearchByGenres= '$artistsEndpoint/search/by_genres';
  static const String artistsRecentRelease= '$artistsEndpoint/recent_releases';
  static const String artistsSearchByAvgVote= '$artistsEndpoint/by_avg_vote';

  // bands end-point
  static const String bandsEndpoint = '/bands';
  static const String bandsMostVoted= '$bandsEndpoint/search/by_avg_vote';
  static const String bandsMostListened= '$bandsEndpoint/most_listened';
  static const String bandsSearchByGenres= '$bandsEndpoint/search/by_genres';


  // songs end-point
  static const String songsEndpoint= '/songs';
  static const String songsSortedLongest = '$songsEndpoint/sorted/longest';
  static const String songsSortedShortest = '$songsEndpoint/sorted/shortest';
  static const String songsSearchByName = '$songsEndpoint/search/by_name';
  static const String songsSearchByGenres = '$songsEndpoint/search/by_genres';
  static const String songsMostListened = '$songsEndpoint/most_listened';
  static const String songsSearchByArtist = '$songsEndpoint/search/by_artist';

  // genres end-point
  static const String genresEdnpoint= '/genres';
  static const String genresSearchByPrefix = '$genresEdnpoint/search/by_prefix';
  static const String genresMostListened = '$genresEdnpoint/most_listened';
  static const String genresSearchByAvgVote = '$genresEdnpoint/search/by_avg_vote';
  static const String genresMostFollowed = '$genresEdnpoint/most_followed';


  //review end-point
  static const String reviewEndpoint= '/album_reviews';
  static const String reviewSearchByDate = '$reviewEndpoint/search/by_date';
  static const String reviewSearchByRating = '$reviewEndpoint/search/by_rating';
  static const String reviewSearchDetailed = '$reviewEndpoint/search/detailed';
  static const String reviewSearchByKeyword = '$reviewEndpoint/search/by_keyword';
  static const String reviewSearchByUser = '$reviewEndpoint/user';
  static const String reviewSearchByArtist = '$reviewEndpoint/artist';
  static const String reviewSearchByAlbum= '$reviewEndpoint/album/';
  static const String reviewCreate = '$reviewEndpoint/review';

  // solo_artists end point
  static const String reviewsEndPoint = '/solo_artists';
  static const String soloArtistByInstrument = '$reviewsEndPoint/search/by_instrument';
  static const String soloArtistMostListened = '$reviewsEndPoint/most_listened';
  static const String soloArtistByName = '$reviewsEndPoint/search/by_name';
  static const String soloArtistByGenres = '$reviewsEndPoint/search/by_genres';
  static const String soloArtistByAvgVote = '$reviewsEndPoint/search/by_avg_vote';
  static const String soloArtistMostFollowed = '$reviewsEndPoint/most_followed';

  // users end-point
  static const String usersEndpoint = '/users';


  // addresses
  static final String ADDRESS_STORE_SERVER = "localhost:8082";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8080";

  // authentication
  static final String REALM = "ProgettoPSW";
  static final String CLIENT_ID = "album-app";
  static final String CLIENT_SECRET = "IlJkz6lNn9zSgsc7af8BCcsqGlWhe5K8";
  static final String REQUEST_LOGIN = "/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/realms/" + REALM + "/protocol/openid-connect/logout";

  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";


  // requests
  static final String REQUEST_SEARCH_PRODUCTS = "/products/search/by_name";
  static final String REQUEST_ADD_USER = "/users";

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Text Styles
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 16.0;
  static const double bodyFontSize = 14.0;

  // Assets Path
  static const String albumCoversPath = 'assets/images/albums/';
  static const String defaultAlbumCover = 'assets/images/default_album.png';

  // Supported image extensions
  static const List<String> supportedImageExtensions = [
    '.jpg', '.jpeg', '.png', '.webp', '.gif'
  ];
}