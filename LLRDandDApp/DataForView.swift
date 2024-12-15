//
//  DataForView.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 9.12.2024.
//

import Foundation

struct DataStructForTopBar{
    let title: String
    let settingsImage: String
    let filterImage: String
}

struct DataForTopBarMenu: DataDelegatForTopBarOnli{
    // передача данных неоходимых для верхнего бара на странице меню
    func fetchData() -> DataStructForTopBar {
        return DataStructForTopBar(title: "Menu",
                                   settingsImage: "gear",
                                   filterImage: "line.3.horizontal.decrease")
    }
}

struct DataForTopBarSettings: DataDelegatForTopBarOnli{
    // передача данных неоходимых для верхнего бара на странице настроик
    func fetchData() -> DataStructForTopBar {
        return DataStructForTopBar(title: "Settings",
                                   settingsImage: "gear",
                                   filterImage: "line.3.horizontal.decrease")
    }
}

struct DataForTopBarFiltration: DataDelegatForTopBarOnli{
    // передача данных неоходимых для верхнего бара на странице фильтрации
    func fetchData() -> DataStructForTopBar {
        return DataStructForTopBar(title: "Fillter",
                                   settingsImage: "gear",
                                   filterImage: "line.3.horizontal.decrease")
    }
}

struct DataForTopBarInfo: DataDelegatForTopBarOnli{
    // передача данных неоходимых для верхнего бара на странице информации
    func fetchData() -> DataStructForTopBar {
        return DataStructForTopBar(title: "Information",
                                   settingsImage: "gear",
                                   filterImage: "line.3.horizontal.decrease")
    }
}


//Создаём структуру данных необходимых для меню фильтрации
struct DataStructForFilter{
    let category: String
    let priceSlider: String
    let categoryAll: String
    let categoryMain: String
    let categoryDrinks: String
    let categoryDessert: String
    
    let textForBackButton: String
}

// Обрабатываем и возвращаем в меню фильтрации
struct FilterData: DataDelegateForScreen{
    func fetchData() -> DataStructForFilter{
        return DataStructForFilter(category: "Chose category",
                                   priceSlider: "Change max price",
                                   categoryAll: "All",
                                   categoryMain: "Main dish",
                                   categoryDrinks: "Drinks",
                                   categoryDessert: "Dessert",
                                   textForBackButton: "Accept"
        )
    }
}

struct SettingsDataStruct{
    let mainText: String
    let textForButtonTheme: String
    let textForBackButton: String
}

struct SettingsData: DataDelegateForScreen{
    func fetchData() -> SettingsDataStruct {
        return SettingsDataStruct(mainText: "Change theme",
                                  textForButtonTheme: "Press",
                                  textForBackButton: "Accept")
    }
}



//final class Dishes: Identifiable{
//
//    let dishesCategory: Category
/*
    let id = UUID()
    let name: String
    let price: Double
    let ingridients: [String]
    let peculiarity: String
    let isHot: String
    let isAlcogolic: String
    let withsugar: String
    
    init(dishesCategory: Category,
         name: String,
         price: Double,
         ingridients: [String],
         peculiarity: String,
         isHot: String,
         isAlcogolic: String,
         withsugar: String) {
        self.dishesCategory = dishesCategory
        self.name = name
        self.price = price
        self.ingridients = ingridients
        self.peculiarity = peculiarity
        self.isHot = isHot
        self.isAlcogolic = isAlcogolic
        self.withsugar = withsugar
    }
}
 */




// Создаём единную структуру для обьектов меню
struct Dishes: Identifiable{
    
    let dishesCategory: Category
    
    let id = UUID()
    let Title: String
    let name: String
    let price: Double
    let ingridients: [String]
    let peculiarity: String
    let isHot: String
    let isAlcogolic: String
    let withsugar: String
    
}
// Создаём обьект структуры
let allFood = [
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 6.66,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 20,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 15,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 2,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 30,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Fried Chicken",
           price: 10,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .mainFood,
           Title: "Main Food",
           name: "Super Pasta",
           price: 9.99,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Type of dish",
           isHot: "Hot",
           isAlcogolic: "",
           withsugar: ""
          ),
    Dishes(dishesCategory: .drinks,
           Title: "Drinks",
           name: "Marrrgarita",
           price: 23,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Availability of alcohol",
           isHot: "",
           isAlcogolic: "Yes",
           withsugar: ""
          ),
    Dishes(dishesCategory: .drinks,
           Title: "Drinks",
           name: "Pivo",
           price: 1.5,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Availability of alcohol",
           isHot: "",
           isAlcogolic: "No",
           withsugar: ""
          ),
    Dishes(dishesCategory: .drinks,
           Title: "Drinks",
           name: "Pivo",
           price: 1.5,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Availability of alcohol",
           isHot: "",
           isAlcogolic: "No",
           withsugar: ""
          ),
    Dishes(dishesCategory: .drinks,
           Title: "Drinks",
           name: "Pivo",
           price: 1.5,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Availability of alcohol",
           isHot: "",
           isAlcogolic: "No",
           withsugar: ""
          ),
    Dishes(dishesCategory: .drinks,
           Title: "Drinks",
           name: "Pivo",
           price: 1.5,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Availability of alcohol",
           isHot: "",
           isAlcogolic: "No",
           withsugar: ""
          ),
    Dishes(dishesCategory: .desserts,
           Title: "Dessert",
           name: "Affogato",
           price: 9.50,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Sugar free",
           isHot: "",
           isAlcogolic: "",
           withsugar: "Yes"
          ),
    Dishes(dishesCategory: .desserts,
           Title: "Dessert",
           name: "Affogato",
           price: 9.50,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Sugar free",
           isHot: "",
           isAlcogolic: "",
           withsugar: "Yes"
          ),
    Dishes(dishesCategory: .desserts,
           Title: "Dessert",
           name: "Affogato",
           price: 9.50,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Sugar free",
           isHot: "",
           isAlcogolic: "",
           withsugar: "Yes"
          ),
    Dishes(dishesCategory: .desserts,
           Title: "Dessert",
           name: "Affogato",
           price: 9.50,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Sugar free",
           isHot: "",
           isAlcogolic: "",
           withsugar: "Yes"
          ),
    Dishes(dishesCategory: .desserts,
           Title: "Dessert",
           name: "Affo",
           price: 4.20,
           ingridients: ["Chicken", "oil", "salt"],
           peculiarity: "Sugar free",
           isHot: "",
           isAlcogolic: "",
           withsugar: "No"
          )
]

// Создаём контент для разных вкладок еды

struct SectionMainStructData: DataDelegateForScreen{
    func fetchData() -> String {
        return "Main"
    }
}

struct SectionDkinksStructData: DataDelegateForScreen{
    func fetchData() -> String {
        return "Drinks"
    }
}

struct SectionDessertStructData: DataDelegateForScreen{
    func fetchData() -> String {
        return "Deserts"
    }
}

//Обробатываем дату для страницы еды

struct DataMainFoodsOnli: DataDelgatForCards{
    var content: [Dishes]
    func fetchData() -> [Dishes] {
        var mainDishes: [Dishes] = []
        for item in content{
            if(item.dishesCategory == .mainFood){
                mainDishes.append(item)
            }
        }
        print(mainDishes)
        return mainDishes
    }
}

struct DataDrinksOnli: DataDelgatForCards{
    var content: [Dishes]
    func fetchData() -> [Dishes] {
        var drinks: [Dishes] = []
        for item in content{
            if(item.dishesCategory == .drinks){
                drinks.append(item)
            }
        }
        print(drinks)
        return drinks
    }
}

struct DataDessertsOnli: DataDelgatForCards{
    var content: [Dishes]
    func fetchData() -> [Dishes] {
        var desserts: [Dishes] = []
        for item in content{
            if(item.dishesCategory == .desserts){
                desserts.append(item)
            }
        }
        print(desserts)
        return desserts
    }
}

struct DataForInfoScreen{
    let nameForPicture: String
    let nameForButton: String
}

struct ContentForInfoPage: DataDelegateForScreen{
    func fetchData() -> DataForInfoScreen {
        return DataForInfoScreen(nameForPicture: "LittleLemonLogo",
                                 nameForButton: "Back To Main")
    }
}

struct DishCardData: DataDelgatForDishInfo{
    
    let DishInfoForSrcreen: Dishes
    func fetchData() -> Dishes {
        return DishInfoForSrcreen
    }
}

func Combining(_ list: [String]) -> String{
    var result = ""
    var check = 1
    
    for item in list{
        if check < list.count{
            result = result  + item + ", "
            check += 1
        }else{
            result = result + item
        }
    }
    
    return result
}

func FilterForFood(_ dishes: [Dishes], _ maxPrice: Double) -> [Dishes]{
    return dishes.filter{ $0.price <= maxPrice }
}


