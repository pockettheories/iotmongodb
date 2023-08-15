require 'mongo'
require 'json'
require 'cli/ui'

mongouri = ENV['mongouri'] || 'mongodb://host.docker.internal'
dbname = ENV['dbname'] || 'test'
collname = ENV['collname'] || 'readings'
bucketsize = (ENV['bucketsize'] || 5).to_i
sleeptime = (ENV['sleeptime'] || 1).to_i
mode = ENV['demomode'] || 'basic'

client = Mongo::Client.new mongouri
client = client.use dbname

CLI::UI.frame_style= :bracket
CLI::UI::StdoutRouter.enable

loop do
  val_to_insert = rand(30..50)

  if mode == 'basic'
    doc = client[collname].find_one_and_update(
      {meter: 'A1', reading_count: {'$lt': bucketsize}},
      {'$push': {'reading': val_to_insert}, '$inc': {reading_count: 1}},
      {upsert: true, return_document: :after}
    )
    CLI::UI::Frame.open("Record reading #{val_to_insert}") do
      puts CLI::UI.fmt "{{green:Executing}}"
      puts "
  db.#{collname}.updateOne(
    {meter: 'A1', reading_count: {$lt: bucketsize}},
    {$push: {'reading': #{val_to_insert}}, $inc: {reading_count: 1}},
    {upsert: true}
  );
    "
      puts CLI::UI.fmt "{{green:Output document}}"
      puts JSON.pretty_generate(doc)
    end  # End of Frame.open
  elsif mode == 'advanced'
    dt_now = DateTime.now
    doc = client[collname].find_one_and_update(
      {meter: 'A1', reading_count: {'$lt': bucketsize}},
      {'$push': {'reading': val_to_insert, 'reading_ts': dt_now}, '$inc': {reading_count: 1, reading_total: val_to_insert}, '$max': {max_ts: dt_now, max_reading: val_to_insert}, '$min': {min_ts: dt_now, min_reading: val_to_insert} },
      {upsert: true, return_document: :after}
    )
    CLI::UI::Frame.open("Record reading #{val_to_insert}") do
      puts CLI::UI.fmt "{{green:Executing}}"
      puts "
  db.#{collname}.updateOne(
    {meter: 'A1', reading_count: {$lt: bucketsize}},
    {$push: {'reading': #{val_to_insert}, 'reading_ts': #{dt_now}}, $inc: {reading_count: 1, reading_total: #{val_to_insert}}, $max: {max_ts: #{dt_now}, max_reading: #{val_to_insert}, $min: {min_ts: #{dt_now}, min_reading: #{val_to_insert}},
    {upsert: true}
  );
    "
      puts CLI::UI.fmt "{{green:Output document}}"
      puts JSON.pretty_generate(doc)

      # query_result = client[collname].aggregate([
      #                                             {}
      #                                           ])

    end  # End of Frame.open
  end  # End of mode == 'basic'

  sleep sleeptime
end

