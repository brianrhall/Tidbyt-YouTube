load("render.star", "render")
load("encoding/base64.star", "base64")
load("http.star", "http")
load("humanize.star", "humanize")

# Replace CHANNEL_ID and API_KEY with your values
YOUTUBE_VIDEO_API = "https://www.googleapis.com/youtube/v3/search?key=API_KEY&channelId=CHANNEL_ID&part=snippet,id&order=date&maxResults=1"

YOUTUBE_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAA0AAAAJCAYAAADpeqZqAAAAAXNSR0IArs4c6QAAAEZJREFUKFOd0EEKACAIBMDd/z/aSDLQEM0OXnIUlxg8mhFAKk9A+7U4IMfyznOzNsyRtQbcQwH30Nem6qYnjCRGl14Vdfxfva8YCrjCNQ4AAAAASUVORK5CYII=""")

# set colors
white_color="#FFFFFF" # white

def main():

	VideoInfo = http.get(YOUTUBE_VIDEO_API)
	if VideoInfo.status_code != 200:
		fail("Random number generation failed with status %d", VideoInfo.status_code)

	videoID = VideoInfo.json()["items"][0]["id"]["videoId"]
	videoTitle = VideoInfo.json()["items"][0]["snippet"]["title"]

	YOUTUBE_STATS_API = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=" + videoID + "&key=AIzaSyCA0isEyNnFd8tNGRn-mG0uD92R1Kf01Jc"

	YouTubeData = http.get(YOUTUBE_STATS_API)
	if YouTubeData.status_code != 200:
		fail("Random number generation failed with status %d", YouTubeData.status_code)

	viewCount = YouTubeData.json()["items"][0]["statistics"]["viewCount"]
	viewCount = humanize.comma(int(viewCount))

	likeCount = YouTubeData.json()["items"][0]["statistics"]["likeCount"]
	likeCount = humanize.comma(int(likeCount))

	commentCount = YouTubeData.json()["items"][0]["statistics"]["commentCount"]
	commentCount = humanize.comma(int(commentCount))
	
	return render.Root(
	delay = 60,
	child = render.Column(
	    expanded=True,
            main_align="space_evenly",
            children = [
		render.Row(
			expanded=True,
			main_align="start",
			cross_align="center",
                		children = [
                    		render.Image(src=YOUTUBE_IMG, width=13, height=9),
                        		render.Marquee(
					width=64,
					child=render.WrappedText(videoTitle, color=white_color),
					offset_start=16,
					offset_end=16,
				),
                		],
            	),
	    	render.Row(
                		expanded=True,
                		main_align="start",
                		cross_align="center",
			children = [
                			render.Column(
                      			main_align="center",
                      			cross_align="start",
                      			expanded=True,
                      			children=[
                        				render.Text("   " + "Views: " + viewCount, color=white_color, font="tom-thumb"),
                        				render.Text("   " + "Likes: " + likeCount, color=white_color, font="tom-thumb"),
                        				render.Text("Comments: " + commentCount, color=white_color, font="tom-thumb"),
                      			],
                    		),
			],
            	),
	],
	),
    )
