import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/VideoModel.dart';
import 'package:moodymuch/screens/youtube/components/youtube_video_screen.dart';
import 'package:moodymuch/services/youtubeAPIService.dart';


class YoutubeVideoListScreen extends StatefulWidget {

  final String title;
  final String playlistID;
  YoutubeVideoListScreen({Key key, this.title, this.playlistID}) : super(key: key);
  @override
  _YoutubeVideoListScreenState createState() => _YoutubeVideoListScreenState();
}

class _YoutubeVideoListScreenState extends State<YoutubeVideoListScreen> {
  List<Video> _videos;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPlaylist();
  }

  @override
  void dispose() {
    APIService.instance.setToken('');
    super.dispose();
  }

  _initPlaylist() async {
    List<Video> videos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.playlistID);
    setState(() {
      _videos = videos;
    });
  }


  _buildVideo(Video video) {
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
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.playlistID);
    List<Video> allVideos = _videos..addAll(moreVideos);
    setState(() {
      _videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _videos != null && _videos.length > 0
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!_isLoading &&
              _videos.length != APIService.instance.totalVideos &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
            _loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _videos.length,
          itemBuilder: (BuildContext context, int index) {
            Video video = _videos[index];
            return _buildVideo(video);
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
