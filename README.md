# strava_uploader
A CLI for uploading Strava activities. Optimized for speed-to-post based on your routines.

<a href="https://asciinema.org/a/JXQtFHhQaY8NzxhvNEbKnZ4nv"><img src="https://asciinema.org/a/JXQtFHhQaY8NzxhvNEbKnZ4nv.png" width="400" height="500"/></a>


# How to start
1. Get a Strava app key\*:
    * Create a Strava app: `https://www.strava.com/settings/api` . Say you're an importer or something.
    * Follow the steps in here, use the access token you get: `https://yizeng.me/2017/01/11/get-a-strava-api-access-token-with-write-permission/`.
    * Put it in `.secret/api_keys.rb`.
2. Run `./strava.rb`. You may need to install a handful of gems.

\* In an ideal world, I'd host a server so you could do proper OAuth and this would be so much nicer. Sorry 🤔.

# Options
Watch the video above, it shows this in action.

The options are pretty non-standard. The most common use case is `./strava.rb <workout>`, using your workout template and the editor from there.

```
~/Documents/strava_uploader:eoin[master✌️ 🚀 ]✔$ ./strava.rb 
strava
  -> prints help
strava list
  -> gives a full list of supported workout templates
strava upper
  -> posts standard upper body workout
strava upper +<exercise>:<number_of_sets>:<number_of_reps>:<weights>
  -> Adds the following to the description:
  ->  "<exercise>: <number_of_sets> sets of <number_of_reps> reps at weight1->weight2->weight3"
strava upper -<exercise>
  -> posts a standard workout, minus that particular thing
strava upper time:50
  -> Lets you post a workout time, in minutes. It must come AFTER the workout name itself (sorry!)
strava custom +<exercise>:<number_of_sets>:<number_of_reps>:<weights>
  -> does not use any standard template, expects a number of exercises to be specified.
==============================
Advanced:
strava upper dry
  -> dry run, prints the output without POSTing to strava.
    dry can be anywhere in the args after the initial workout argument.
strava upper skip
  -> skips the editor for customizing the message. Same caveat as dry.
```

# Customizing

The whole point of this is you can upload activities, over and over again, very quickly. You probably don't want the default templates. All you need to do is update the `WORKOUT_TEMPLATES` hash in `workout_template.rb` to reflect something like your usual.
