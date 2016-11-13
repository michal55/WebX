# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Doorkeeper::Application.create('name' => 'WebX Extension', 'uid' => '19e161e3cf0f594fb87f3e4810e041c45530861c56883ce09b2ff2a54a99fe39', 'secret' => 'ee113671f1a334fb9fba9289ca9af6a325cc890c1582d84adf35c25cc19ced6d', 'redirect_uri' => 'https://kkdachbmijclgbobkhiodnpnmajmfnog.chromiumapp.org/', 'scopes'=> '')
