# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

dogs = Animal.create!([
    {animal_type_id: 1, nickname: "Бомбора", surname: "нет", gender: "M", color: "белый пушистый", aviary_id: 4},
    {animal_type_id: 1, nickname: "Макси", surname: "нет", gender: "M", color: "рыжий гладкошерстый", aviary_id: 4},
    {animal_type_id: 1, nickname: "Прохор", surname: "нет", gender: "M", color: "рыжий пестрый пушистый", aviary_id: 5},
    {animal_type_id: 1, nickname: "Дружок", surname: "нет", gender: "M", color: "черный с белым", aviary_id: 6},
    {animal_type_id: 1, nickname: "Малыш", surname: "Кроликовы", gender: "M", color: "белый пушистый с темными пятнами на голове и теле, похож на Бусю", aviary_id: 1},
    {animal_type_id: 1, nickname: "Цота", surname: "нет", gender: "M", color: "среднего размера, светло-бежевый с чуть более светлым рисунком на морде", aviary_id: 1},
    {animal_type_id: 1, nickname: "Терри", surname: "нет", gender: "M", color: "кучерявая средняя темного размера", aviary_id: 1},
    {animal_type_id: 1, nickname: "Ба́та", surname: "", gender: "M", color: "пушистый, типа Чучи", aviary_id: 1},
    {animal_type_id: 1, nickname: "Ая", surname: "нет", gender: "Ж", color: "черный с белым", aviary_id: 6},
    {animal_type_id: 1, nickname: "Кира (?)", surname: "нет", gender: "Ж", color: "небольшая темная с рыжими участками, гладкошерстая", aviary_id: 6},
    {animal_type_id: 1, nickname: "Буба", surname: "Бубадзе", gender: "M", color: "", aviary_id: 6},
    {animal_type_id: 1, nickname: "Амба", surname: "Сомхэбишвили", gender: "Ж", color: "", aviary_id: 6},
    {animal_type_id: 1, nickname: "Малхазовна", surname: "Малхазовские", gender: "Ж", color: "", aviary_id: 6},
    {animal_type_id: 1, nickname: "Леди, похожая на Кохту", surname: "", gender: "Ж", color: "пушистая охотничья, черная", aviary_id: 6},
    {animal_type_id: 1, nickname: "Алабама", surname: "нет", gender: "Ж", color: "", aviary_id: 6},
    {animal_type_id: 1, nickname: "Надежда", surname: "нет", gender: "M", color: "черная пушистая с белыми кончиками лап, подбородком и полоской на груди", aviary_id: 2},
    {animal_type_id: 1, nickname: "Марек", surname: "нет", gender: "М", color: "трехлапый, белый с коричневыми пятнами вокруг глаз и ушами", aviary_id: 3}
])