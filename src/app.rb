require 'mongo'
require 'json'

mongouri = ENV['mongouri'] || 'mongodb://host.docker.internal'
dbname = ENV['dbname'] || 'test'
collname = ENV['collname'] || 'readings'
bucketsize = (ENV['bucketsize'] || 5).to_i
sleeptime = (ENV['sleeptime'] || 1).to_i

client = Mongo::Client.new mongouri
client = client.use dbname

loop do
  val_to_insert = rand(30..50)
  doc = client[collname].find_one_and_update(
    {meter: 'A1', reading_count: {'$lt': bucketsize}},
    {'$push': {'reading': val_to_insert}, '$inc': {reading_count: 1}},
    {upsert: true, return_document: :after}
  )

  puts "
Executing:
  db.#{collname}.updateOne(
    {meter: 'A1', reading_count: {$lt: bucketsize}},
    {$push: {'reading': #{val_to_insert}}, $inc: {reading_count: 1}},
    {upsert: true}
  );
  "
  puts "//Inserted #{val_to_insert}"
  puts ''
  puts 'Output document:'
  puts JSON.pretty_generate(doc)
  sleep sleeptime
end

