import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/ChannelModel.dart';
import 'package:moodymuch/model/VideoModel.dart';
import 'package:moodymuch/screens/youtube/components/youtube_video_screen.dart';
import 'package:moodymuch/services/youtubeAPIService.dart';


class YoutubeVideoListScreen extends StatefulWidget {

  String title;
  YoutubeVideoListScreen({Key key, this.title}) : super(key: key);
  @override
  YoutubeVideoListScreenState createState() => YoutubeVideoListScreenState(title);
}

class YoutubeVideoListScreenState extends State<YoutubeVideoListScreen> {
  Channel channel;
  List<Video> playlist;
  bool isLoading = false;
  String title;

  YoutubeVideoListScreenState(this.title);

  String pilatesPlayListID = "PLKzpgYNAcbwJ5v3Rt07CPx_yFnNAHJC7z";
  String yogaForKidsPlayListID = "PLc0asrzrjtZJWljYTAwKM6mdb4RfoiSxx";
  String yogaForAdultsPlaylistID = "PLP7Ou7uUiYzCmZNNTKKjPZ8h01krmY8Fr";
  String mindfulnessPlaylistID = 'PLCQACBUblTbXAgZG7cxMYUddUlvTDO6v1';
  String spiritualPlaylistID = 'PLM_5z7EKcBv9hI7ABzjC37wPH0VAcQ0qU';
  String focusedPlaylistID = 'PLIw7E3llngHATo7IpCsS24_7dPJjzfd3t';
  String mantraPlaylistID = 'PLsuCfYXzi5DLisEHBoBKtVwkQ6WQub_Dh';
  String lovingKindnessPlaylistID = 'PL_jEEejSTzLz1jahZZLZsek1GMDpdG0cs';
  String exercisePlaylistID = "PLQSMS0J6JbrKdSOSbyJXaQ_zN_HSSp7zZ";
  String selectedPlaylistID;

  @override
  void initState() {
    super.initState();
    initPlaylist();
  }

  initChannel() async {
    Channel _channel = await APIService.instance.fetchChannel(channelId: 'UCjzHeG1KWoonmf9d5KBvSiw');
    setState(() {
      channel = _channel;
    });
  }

  initPlaylist() async {
    switch(title) {
      case "Pilates":
        selectedPlaylistID = pilatesPlayListID;
        break;
      case "Meditation":
        selectedPlaylistID = spiritualPlaylistID;
        break;
      case "Yoga":
        selectedPlaylistID = yogaForAdultsPlaylistID;
        break;
      case "Exercise":
        selectedPlaylistID = exercisePlaylistID;
        break;
    }

    print(selectedPlaylistID);
    List<Video> _playlist = await APIService.instance.fetchVideosFromPlaylist(playlistId: selectedPlaylistID);
    setState(() {
      playlist = _playlist;
    });
  }


  buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              fit: BoxFit.fill,
              width: 125.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);
    List<Video> allVideos = channel.videos..addAll(moreVideos);
    setState(() {
      channel.videos = allVideos;
    });
    isLoading = false;
  }

  loadMoreVideos() async {
    isLoading = true;
    List<Video> allVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: selectedPlaylistID);
    setState(() {
      playlist = allVideos;
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: playlist != null
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!isLoading && scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent) {
            loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (BuildContext context, int index) {
            Video video = playlist[index];
            return buildVideo(video);
          },
        ),
      )
      : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            kPrimaryColor,
          ),
        ),
      )
    );
  }
}
