# Tidbyt-YouTube

[Tidbyt](https://tidbyt.com/) integration with the YouTube API. You simply need to replace the CHANNEL\_ID and API\_KEY with your values.

The default YouTube applet for Tidbyt did not have the detail I wanted, nor did they open source it, so here are alternate versions. Both **YouTube** and **LatestVideo** include horizontal scrolling for the channel name and video name, respectively.

Starlark, and more specifically `pixlet 0.16.0` and earlier does not support external files, libraries, string formatting, or some other basic functionality so I wrote my own comma insertion function, which I have now depricated, but you can find below. Beginning with `pixlet 0.17.0` the module "humanize" can be used for formatting some basic data types.

| Channel Stats | Latest Video |
:-------------------------:|:-------------------------:
| ![Alt](./images/youtubeStatsSmall.png "youtube stats") | ![Alt](./images/latestVideo.jpg "latest video") |
 
## Static
<p align="center"><img src="./images/latestVideo.jpg" alt="latest video stats"><br /><span align="center"><i>Latest Video Details</i></span>
</p>

## Animation
<p align="center"><img src="./images/youtubeStats.gif" alt="channel stats"><br /><span align="center"><i>YouTube Channel Details</i></span>
</p>

## Humanize Alternative
Humanize is perhaps the worst name for a code module...but anyway you can add commas to values as follows. Requires `pixlet  0.17.0` or higher.

At the top of the file with the rest of the modules make sure you load "humanize".
<pre>load("humanize.star", "humanize")</pre>

And then for the value do something like this.
<pre>subs = int(YouTubeData.json()["items"][0]["statistics"]["subscriberCount"])
subs = humanize.comma(int(subs))
</pre>

If you want your own comma function, you can use something like what I have below, but I have since removed it from my code since the Starlark dialect for Pixlet no longer supports the `while` statement. Yes, you read that correctly.
<pre>def commas(value):
   converted\_value = str(value)
   output = ""
   i = 0
   length = len(converted\_value)
   while i < length:
      count = 0
      if (count < 2):
         output = converted\_value[length - (i + 1)] + output
         count += 1
         i += 1
      if (i % 3 == 0) and (i < length):
      output = "," + output
   return output
</pre>