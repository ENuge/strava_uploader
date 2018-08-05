#!/usr/local/bin/ruby
require 'json'
require 'ostruct'
require 'pry-nav'
require 'requests'
require 'tempfile'
require_relative './workout_templates'
require_relative '.secret/api_keys'

# Takes a generic description and adds additions / removes subtractions.
# If subtractions are not in the original description, it does nothing.
def alter_description(description, additions, subtractions)
  new_description = description
  additions.each do |addition|
    stylized_weights = addition.weights&.join('->')
    if stylized_weights == '' || stylized_weights.nil?
      stylized_weights = 'body weight'
    end
    
    # This will look off for things I do 1 set or rep of,
    # but I'm ok with that - it makes eventually parsing
    # a dump of my data from Strava in the future easier.
    new_description << <<~EOF
      #{addition.exercise}: #{addition.num_sets} sets of #{addition.num_reps} reps at #{stylized_weights} lbs
    EOF
  end
  subtractions.each do |subtraction|
    new_description_array = new_description.split("\n").reject do |line|
      line.index(subtraction) == 0
    end
    new_description = new_description_array.join("\n")
  end

  new_description
end

def check_description_editor(description)
  editor = ENV.fetch('EDITOR') {'vi'}
  Tempfile.create do |f|
    f.write(description)
    f.close
    system("#{editor} #{f.path}")
    IO.read(f.path)
  end
end

def parse_options
  if ARGV.empty?
    puts <<~EOF
      You must specify your workout. Here are some examples:
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
    EOF
    exit
  elsif ARGV[0] == 'list'
    puts <<~EOF
      Valid arguments:
      #{WORKOUT_TEMPLATES.keys}
      Corresponding to these names and descriptions:
      (You are intended to supply all the exercises for `custom`.)
      #{JSON.pretty_generate(WORKOUT_TEMPLATES)}
    EOF
    exit
  elsif ARGV[0] == 'custom'
    puts "You said custom - we're not using any workout template."
  elsif !WORKOUT_TEMPLATES.keys.include?(ARGV[0])
    puts <<~EOF
      #{ARGV[0]} is an invalid argument. The possible values are: #{WORKOUT_TEMPLATES.keys}.
      Run `strava` with no arguments for a more verbose description.
    EOF
    exit
  end

  workout_type = ARGV[0]
  additions = []
  subtractions= []
  custom_time = nil
  dry_run = nil
  skip_editor = nil
  ARGV.slice(1..ARGV.length).each do |argument|
    if argument.start_with?('+')
      addition = OpenStruct.new
      addition.exercise, addition.num_sets, addition.num_reps, weights = argument[1..argument.length].split(':')
      addition.weights = weights&.split(',')
      if !addition.exercise || !addition.num_sets || ! addition.num_reps
        puts <<~EOF
          You must specify the exercise, num_sets, and num_reps (and optionally weights), like so:
            "+exercise:num_sets:num_reps:weights"
        EOF
        exit
      end
      if !addition.weights
        puts "No weight specified - that's fine, we'll assume it's using body weight."
      end
      additions << addition
    elsif argument.start_with?('-')
      subtractions << argument[1..argument.length]
    elsif argument.index('time:') == 0
      custom_time = argument.split('time:')[1]
    elsif argument == 'dry'
      dry_run = true
    elsif argument == 'skip'
      skip_editor = true
    else
      puts "Argument: #{argument} must start with + or - (to denote adding or removing a given workout)."
    end
  end

  [workout_type, additions, subtractions, custom_time, dry_run, skip_editor]
end

def main(workout_name, description, custom_time, dry_run)
  strava_url = "https://www.strava.com/api/v3/activities"
  params = {
    name: workout_name,
    description: description,
    type: "Workout",
    private: 1,
  }
  params['start_date_local'] = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
  if custom_time
    params['elapsed_time'] = custom_time.to_i * 60
  else
    params['elapsed_time'] = 75*60 # Assume 75 minute workouts (Strava accepts time in seconds)
  end

  strava_auth_header = {Authorization: "Bearer #{STRAVA_API_KEY}"}
  activity_id = nil
  if !dry_run
    response = Requests.request("POST", strava_url, params: params, headers: strava_auth_header)
    activity_id = JSON.parse(response.body)["id"]
  end

  puts "============================================================="
  puts "= ⚡️Brodin is pleased with your contribution. Keep it up!⚡️ ="
  if activity_id
    puts "= ⚡️Strava: https://www.strava.com/activities/#{activity_id} ⚡️ ="
  end
  puts "============================================================="

  puts "Workout Summary:"
  puts "\t #{JSON.pretty_generate(params)}"
end

workout_type, additions, subtractions, custom_time, dry_run, skip_editor = parse_options()
workout_name = WORKOUT_TEMPLATES[workout_type][:name]
standard_description = WORKOUT_TEMPLATES[workout_type][:description]
customized_description = alter_description(standard_description, additions, subtractions)
if !skip_editor
  customized_description = check_description_editor(customized_description)
end
main(workout_name, customized_description, custom_time, dry_run)