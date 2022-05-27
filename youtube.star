load("render.star", "render")
load("encoding/base64.star", "base64")
load("http.star", "http")

# Replace CHANNEL_ID and API_KEY with your values
YOUTUBE_INFO_API = "https://www.googleapis.com/youtube/v3/channels?part=snippet&id=CHANNEL_ID&key=API_KEY"
YOUTUBE_STATS_API = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=CHANNEL_ID&key=API_KEY"

YOUTUBE_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAA0AAAAJCAYAAADpeqZqAAAAAXNSR0IArs4c6QAAAEZJREFUKFOd0EEKACAIBMDd/z/aSDLQEM0OXnIUlxg8mhFAKk9A+7U4IMfyznOzNsyRtQbcQwH30Nem6qYnjCRGl14Vdfxfva8YCrjCNQ4AAAAASUVORK5CYII=""")

# set colors
white_color="#FFFFFF" # white

def commas(value):
	converted_value = str(value)
	output = ""
	i = 0
	length = len(converted_value)
	while i < length:
		count = 0
		if (count < 2):
			output = converted_value[length - (i + 1)] + output
			count += 1
			i += 1
		if (i % 3 == 0) and (i < length):
			output = "," + output
	return output

def main():

	YouTubeInfo = http.get(YOUTUBE_INFO_API)
	if YouTubeInfo.status_code != 200:
		fail("Random number generation failed with status %d", YouTubeInfo.status_code)

	YouTubeData = http.get(YOUTUBE_STATS_API)
	if YouTubeData.status_code != 200:
		fail("Random number generation failed with status %d", YouTubeData.status_code)

	name = YouTubeInfo.json()["items"][0]["snippet"]["title"]

	subs = YouTubeData.json()["items"][0]["statistics"]["subscriberCount"]
	subs = commas(subs)

	views = YouTubeData.json()["items"][0]["statistics"]["viewCount"]
	views = commas(views)

	vids = YouTubeData.json()["items"][0]["statistics"]["videoCount"]
	vids = commas(vids)
	
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
					child=render.WrappedText(name, color=white_color),
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
                        				render.Text(" " + "Subs: " + subs, color=white_color, font="tom-thumb"),
                        				render.Text("Views: " + views, color=white_color, font="tom-thumb"),
                        				render.Text(" " + "Vids: " + vids, color=white_color, font="tom-thumb"),
                      			],
                    		),
			],
            	),
	],
	),
    )
