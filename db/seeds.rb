# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# サンプルユーザー用のEMailとPasswordをパスに通して下さい
# サンプルユーザーが必要ない場合には以下4行をコメントアウトして下さい
user = User.new(:email => ENV["DV_ADMIN_EMAIL"], :password => ENV["DV_ADMIN_PW"], :role => :admin)
user.save!
user = User.new(:email => ENV["DV_SAMPLE_EMAIL"], :password => ENV["DV_SAMPLE_PW"])
user.save!

AutoTagAuthor.create(name: "hadoopqa")
AutoTagAuthor.create(name: "apachespark")
