import 'package:flutter/material.dart';
import 'package:moodymuch/model/ChannelModel.dart';
import 'package:moodymuch/model/VideoModel.dart';
import 'package:moodymuch/screens/youtube/youtube_video_screen.dart';
import 'package:moodymuch/services/youtubeAPIService.dart';


class YoutubeVideoListScreen extends StatefulWidget {
  @override
  _YoutubeVideoListScreenState createState() => _YoutubeVideoListScreenState();
}

class _YoutubeVideoListScreenState extends State<YoutubeVideoListScreen> {
  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCjzHeG1KWoonmf9d5KBvSiw');
    setState(() {
      _channel = channel;
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
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
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
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return _channel != null
        ? NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollDetails) {
        if (!_isLoading &&
            _channel.videos.length != int.parse(_channel.videoCount) &&
            scrollDetails.metrics.pixels ==
                scrollDetails.metrics.maxScrollExtent) {
          _loadMoreVideos();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _channel.videos.length,
        itemBuilder: (BuildContext context, int index) {
          Video video = _channel.videos[index];
          return _buildVideo(video);
        },
      ),
    )
    : Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor, // Red
        ),
      ),
    );
  }
}
