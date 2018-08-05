# Change this as you see fit to match your activities!
# For instance, maybe you swim, add a 'swimming' name
# to workout_templates, then put a little name and
# description and off you go!

UPPER_BODY_DESCRIPTION = <<~EOF
Side Lateral Raise (Seated Dumbbell): 3 sets of 10 reps at 7.5->10->12.5 lbs
Front Lateral Raise (Seated Dumbbell): 3 sets of 10 reps at 12.5->15->15 lbs
Tricep Extension (Seated Dumbbell): 3 sets of 10 reps at 40->40->45 lbs
Shrugs (Seated Dumbbell): 3 sets of 10 reps at 80->90->100 lbs
Bicep Hammer Curl (Seated Dumbbell): 3 sets of 10 reps at 25->27.5->30 lbs
Skull Crushers (Dumbbell): 3 sets of 10 reps at 22.5->25->27.5 lbs
Bench Press (Dumbbell): 3 sets of 10 reps at 40->42.5->45 lbs
Lat Pulldown (Overhead): 3 sets of 10 reps at 120->135->150 lbs
Bicep Pulldown (Overhead): 3 sets of 10 reps at 135->150->150 lbs
Tricep Pushdown: 3 sets of 10 reps at 50->60->60 lbs
EOF

# TODO: Fill out the rest of my PT+leg-strengthening stuff.
LOWER_BODY_DESCRIPTION = <<~EOF
Pistol Squats: 3 sets of 10 reps at 25->30->35
...
EOF

# TODO: Core especially should be able to specify time-based, not rep-based args.
#       Probably something like: `strava core "+Crunches->2m"`
CORE_DESCRIPTION = <<~EOF
Russian Twists: 1 set of 2 minutes
Ab Pulldown: 1 set of 15 reps at 82.5 lbs
Oblique Twist (Cable): 1 set of 15 reps at 47 lbs
Crunch: 1 set of 50 reps
Bicycle Crunch: 1 set of 50 reps
Raised Leg Crunch: 1 set of 50 reps
Leg Raise: 1 set of 35 reps
Bent-Knee Leg Raise: 1 set of 35 reps
Lateral Flutter Kick: 1 set of 35 reps
Up-Down Flutter Kick: 1 set of 35 reps
Ab Hold: 1 set of 2 minutes
Heel Touch Crunch: 1 set of 50 reps
EOF

workout_templates = {
'upper' => {
  name: "💪 Upper-body Workout 🔫",
  description: UPPER_BODY_DESCRIPTION,
},
'lower' => {
  name: "⚡️ Leg Workout ⚡️",
  description: LOWER_BODY_DESCRIPTION, 
},
'core' => {
  name: "🦁 Core Workout 🦍",
  description: CORE_DESCRIPTION,
},
'custom' => {
  name: "Custom Workout",
  description: '',
}
# One could imagine a future where I add, for instance, swimming.
}.freeze