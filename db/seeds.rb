# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

admin = Admin.create!([{:email => "shreya@vinsol.com"}, {:email => "priyank.gupta@vinsol.com"}])

category = Category.create!([{:name => "Web"}, {:name => "IOS"}, {:name => "Android"}, {:name => "Aptitude"}])
