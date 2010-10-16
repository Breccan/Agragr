Ok first, run all this

bundle install
rake db:drop
rake db:create
rake db:migrate
rake db:seed
rake import:hn
rake import:reddit NAME="R/Programming"
rake import:collate

Then the front page should work, need to work out how we're handling topics and things still.

db/seeds.rb has a hash where you should be able to add all the other reddits we want to pull from.

We'll need to look more at finalising those and splitting them up into topics nicely.

Import tasks are in lib/tasks/import.rb if you want to fiddle with fields. 

Start hooking things up, make the javascript shinies. Write a bunch of stuff and tell me what methods I need to create when I wake up for you to get what you need.

Night,
  Breccan
