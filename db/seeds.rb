# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# password "ariel"
ariel = User.create({name: "Ariel", email: "ariel@pollack.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
yossi = User.create({name: "Yossi", email: "yossi@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
dani = User.create({name: "Danni", email: "danni@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
coral = User.create({name: "Coral", email: "coral@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
yanir = User.create({name: "Yanir", email: "yanir@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})

Review.create({rate: 4, user: ariel, writer: coral, details: "Nice person"});
Review.create({rate: 3, user: ariel, writer: dani, details: "cool person"});
Review.create({rate: 5, user: ariel, writer: coral, details: "the best person"});
Review.create({rate: 2, user: yossi, writer: dani, details: "not so good"});
Review.create({rate: 1, user: yossi, writer: yanir, details: "aweful person"});
Review.create({rate: 3, user: yossi, writer: ariel, details: "medium person"});