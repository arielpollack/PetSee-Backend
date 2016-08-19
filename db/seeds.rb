# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# password "ariel"
ariel = Client.create({name: "Ariel", email: "Ariel@polLaCk.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
yossi = ServiceProvider.create({name: "Yossi", email: "yoSSi@aSd.Com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
dani = ServiceProvider.create({name: "Danni", email: "dAnNi@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
coral = Client.create({name: "Coral", email: "coral@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})
yanir = ServiceProvider.create({name: "Yanir", email: "yanir@asd.com", password: "0a2e4da8f53ff496298559b7f100067ec5868c8b"})

pincher = Race.create({name: "Pincher"})
italian = Race.create({name: "Italian Greyhound"})

milky = Pet.create({name: "Milky", race: pincher, color: "black", owner: ariel})
bella = Pet.create({name: "Bella", race: italian, color: "brown", owner: coral})

service = Service.create({client: ariel, pet: milky, type: "dogwalk"})
ServiceRequest.create({service: service, service_provider: yossi})
ServiceRequest.create({service: service, service_provider: dani})
ServiceRequest.create({service: service, service_provider: yanir})
service = Service.create({client: coral, pet: bella, type: "dogsit"})
ServiceRequest.create({service: service, service_provider: yossi})
ServiceRequest.create({service: service, service_provider: yanir})

Review.create({rate: 4, user: ariel, writer: coral, feedback: "Nice person"});
Review.create({rate: 3, user: ariel, writer: dani, feedback: "cool person"});
Review.create({rate: 5, user: ariel, writer: coral, feedback: "the best person"});
Review.create({rate: 2, user: yossi, writer: dani, feedback: "not so good"});
Review.create({rate: 1, user: yossi, writer: yanir, feedback: "aweful person"});
Review.create({rate: 3, user: yossi, writer: ariel, feedback: "medium person"});