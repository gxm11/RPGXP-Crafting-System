# here is the patch for RGSS.
load "dump_scripts.rb" if ENV['AUTOTASK'] == 'dump_scripts'
load "dump_database.rb" if ENV['AUTOTASK'] == 'dump_database'

load 'test_shop.rb' if  ENV['AUTOTASK'] == 'shop'
load 'test_craft.rb' if  ENV['AUTOTASK'] == 'craft'
