# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
admin1 = Admin.find_or_initialize_by_email("shreya@vinsol.com")
admin1.save!
admin2 = Admin.find_or_initialize_by_email("priyank.gupta@vinsol.com")
admin2.save!

category1 = Category.find_or_initialize_by_name("Web")
category1.save!
category2 = Category.find_or_initialize_by_name("IOS")
category2.save!
category3 = Category.find_or_initialize_by_name("Android")
category3.save!
category4 = Category.find_or_initialize_by_name("Aptitude")
category4.save!
