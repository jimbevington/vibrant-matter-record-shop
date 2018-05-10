# config.ru
require "./app"
require "./db/seeds"
run Seeds.seedData()
run App
