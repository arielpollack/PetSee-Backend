json.cache! ['v1', pet] do
    json.extract! pet, :name, :id, :color, :about, :image
    json.race pet.race.name
end