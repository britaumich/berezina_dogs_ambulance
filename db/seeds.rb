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

dogs1 = Animal.create!([
    {animal_type_id: 1, nickname: "Собачий Балка", surname: "", gender: "M", color: "", arival_date: "2023-07-15", aviary_id: ""},
    {animal_type_id: 1, nickname: "Джимбо 2", surname: "", gender: "M", color: "", arival_date: "2023-11-11", history: "появился до 11.11", aviary_id: ""},
    {animal_type_id: 1, nickname: "3 сестры", surname: "", gender: "Ж", color: "", arival_date: "2023-11-12", history: "", aviary_id: "7", from_people: "от Юли (Фадеевой) и Андрея"},
    {animal_type_id: 1, nickname: "Ода", surname: "", gender: "M", color: "", arival_date: "2023-12-08", history: "", aviary_id: "7"},
    {animal_type_id: 1, nickname: "", surname: "", gender: "M", color: "шоколадный, похож на Цику", arival_date: "2023-11-10", history: "щенок с Чхони базара", aviary_id: "", death_date: "2024-01-29"},
    {animal_type_id: 1, nickname: "Тоби", surname: "", gender: "M", color: "", arival_date: "2023-12-20", history: "подкинули к приюту, Саба назвал", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "M", color: "щенок мальчик светлый", arival_date: "2024-01-01", history: "забрали щенка мальчик, щенок от Како (мамаша с обгоревшим боком), соседи нашего строителя Гелы", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "M", color: "", arival_date: "2023-12-08", from_people: "от Малгожаты", description: "рачинец от Малгожаты с опухолью", history: "приступ типа эпилепсии (умер?)", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "Ж", color: "щенок 'панда', белый с черными ушами и кругами на глазах", arival_date: "2024-01-07", history: "сегодня подбросили щенка, девочка, кожные проблемы на лапахмамаша убежала (белая собака)", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "", color: "", arival_date: "2024-01-09", description: "щенок борзой мамаши", history: "", from_people: "сосед Сабы Дато", aviary_id: "7"},
    {animal_type_id: 1, nickname: "Балда", surname: "", gender: "", color: "", arival_date: "2024-01-09", description: "тоже щенок борзой мамаши", history: "", from_people: "родственник Джамбула", aviary_id: ""},
    {animal_type_id: 1, nickname: "Тунтия", surname: "", gender: "", color: "", arival_date: "2024-01-09", description: "", history: "", from_place: "Местия, деревня Лаханула", from_people: "Давид Чкадуа", aviary_id: ""},
    {animal_type_id: 1, nickname: "Макси", surname: "", gender: "М", color: "рыжий", arival_date: "2024-01-09", description: "", history: "", from_place: "", from_people: "Миша", aviary_id: ""},
    {animal_type_id: 1, nickname: "Платон", surname: "", gender: "М", color: "светлый", arival_date: "2024-01-13", description: "", history: "", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Карди", surname: "", gender: "М", color: "темный", arival_date: "2024-01-13", description: "мальчики из Нокалакеви (СТЕРИЛИЗОВАНЫ)", history: "", from_place: "Нокалакеви", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Квинти", surname: "", gender: "Ж", color: "темный", arival_date: "2024-01-13", description: "Квинти + 5 щенков", history: "умер один щенок, остальные около кур", from_place: "", from_people: "", aviary_id: "8"},
    {animal_type_id: 1, nickname: "Аляска", surname: "", gender: "Ж", color: "", arival_date: "2024-01-13", description: "не Лома! сидит около Вардо и Циури на цепи", history: "", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Ярко", surname: "", gender: "М", color: "", arival_date: "2024-01-13", description: "", history: "", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Аби (?)", surname: "", gender: "М", color: "", arival_date: "2024-01-13", description: "", history: "загрызли в Д вольере, сидела с Маквалой и Лобиани", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Люкс", surname: "", gender: "М", color: "", arival_date: "2024-01-13", description: "возраст до года, СТЕРИЛИЗОВАНА", history: "", from_place: "Тбилиси", from_people: "Миша", aviary_id: ""},
    {animal_type_id: 1, nickname: "Элис", surname: "Некстдор", gender: "М", color: "", arival_date: "2024-01-13", description: "старый перелом лапы, СТЕРИЛИЗОВАНА", history: "", from_place: "Тбилиси", from_people: "Миша", aviary_id: ""},
    {animal_type_id: 1, nickname: "Алевтина", surname: "", gender: "Ж", color: "", arival_date: "2024-01-21", description: "попапа 21-22.01 (когда-то до)+ 3 щенка Грей, Рэддисон, Арнольд", history: "Арнольд - Канада, Алевтину тоже отдали (17.03 сделала чип) ЗАПИСАТЬ", from_place: "Тбилиси", from_people: "Миша", aviary_id: ""},
    {animal_type_id: 1, nickname: "Софико (Софа, Сопо)", surname: "", gender: "Ж", color: "", arival_date: "2024-01-31", description: "", history: "улетела в Канаду?", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Намцеца", surname: "", gender: "Ж", color: "", arival_date: "2024-01-31", aviary_id: ""},
    {animal_type_id: 1, nickname: "Леди (маленькая)", surname: "", gender: "M", color: "", arival_date: "2024-02-01", history: "убили в теплом вольере", aviary_id: "9"},
    {animal_type_id: 1, nickname: "Трубоквадратовы", surname: "", gender: "", color: "", arival_date: "2024-02-01", description: "12+13", aviary_id: ""},
    {animal_type_id: 1, nickname: "Амин", surname: "", gender: "M", color: "", arival_date: "2024-02-04", description: "14, мальчик из Губи, белый с черными пятнами, около 2 лет, до 10 кг, не кастрирован", aviary_id: ""},
    {animal_type_id: 1, nickname: "Руби", surname: "", gender: "М", color: "", arival_date: "2024-02-08", description: "у Игоря был отмечен, как Руби. В теплом вольере укусили не сильно, почему-то умер", aviary_id: "9"},
    {animal_type_id: 1, nickname: "Вечер", surname: "", gender: "М", color: "", arival_date: "2024-02-08", description: "15", history: "привязали вечером у приюта Ираклий Гвилава забрал 11.02, вернул до 17.02 (уже был снова у нас)", aviary_id: ""},
    {animal_type_id: 1, nickname: "Дася", surname: "Кефирова", gender: "Ж", color: "", arival_date: "2024-02-11", description: "щ10", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "Ж", color: "", arival_date: "2024-02-14", description: "Собака от Эльдара + 4 щенка (3 девочки, 1 мальчик)", history: "щенки сейчас сидят около кур, мамаша не знаю где и как выглядит", from_people: "Эльдар", aviary_id: "8"},
    {animal_type_id: 1, nickname: "Лиана", surname: "Абхазки", gender: "Ж", color: "черная", arival_date: "2024-02-29", history: "Дато привез щенков из Абхазии, прошли границу без документов", from_place: "Абхазия", from_people: "Дато", aviary_id: ""},
    {animal_type_id: 1, nickname: "Диана", surname: "Абхазки", gender: "Ж", color: "рыжая", arival_date: "2024-02-29", history: "Дато привез щенков из Абхазии, прошли границу без документов", from_place: "Абхазия", from_people: "Дато", aviary_id: ""},
    {animal_type_id: 1, nickname: "Хутшабати", surname: "", gender: "М", color: "", arival_date: "2024-03-01", history: "мальчик, был привязан к забору", from_place: "", from_people: "", aviary_id: "10"},
    {animal_type_id: 1, nickname: "старичок Реми", surname: "", gender: "М", color: "", arival_date: "2024-03-01", history: "подкинули, старенький, сейчас сидит с Альбертиной на палубе у нового кошечника", from_place: "", from_people: "", aviary_id: "11"},
    {animal_type_id: 1, nickname: "Лаура", surname: "", gender: "Ж", color: "", arival_date: "2024-03-04", history: "Лаура + Изабелла, маленькие щенки, привезли из Тбилиси", from_place: "Тбилиси", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Изабелла", surname: "", gender: "Ж", color: "", arival_date: "2024-03-04", history: "Лаура + Изабелла, маленькие щенки, привезли из Тбилиси", from_place: "Тбилиси", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Вахо", surname: "", gender: "М", color: "черный", arival_date: "2024-03-04", history: "", from_place: "", from_people: "Ося", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "Ж", color: "светлая", arival_date: "2024-03-04", description: "девочка из Губи, светлая, СТЕРИЛИЗОВАНА, без понятия кто и как выглядит", from_place: "Губи", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "Ж", color: "светлая", arival_date: "2024-03-04", description: "3 лапы (была со сломанной лапкой, ампутировали 26 марта), это та, что сидит на цепи около складов", history: "девочка из Чхони, с Базробиа", from_place: "из Чхони, с Базробиа", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Марселъ", surname: "", gender: "М", color: "", arival_date: "2024-03-11", description: "некастрированный (тогда был, сейчас проверить)", history: "вернули", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "", surname: "", gender: "М", color: "", arival_date: "2024-03-20", description: "собака с верхнего двора (кто)", history: "похожа на овчарку, покусали сильно Бими, Майна, Жужа и тд (проверить, жива или нет)", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Самия", surname: "", gender: "Ж", color: "", arival_date: "2024-03-23", description: "мелкая трехлапая, судя по чату", history: "убили в М-2", from_place: "", from_people: "", aviary_id: ""},
    {animal_type_id: 1, nickname: "Лапин", surname: "", gender: "М", color: "", arival_date: "2024-03-23", description: "с анаплазмозом после укуса клеща", history: "", from_place: "Тбилиси", from_people: "Миша", aviary_id: ""}
])