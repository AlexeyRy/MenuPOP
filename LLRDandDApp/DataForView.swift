//
//  DataForView.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 9.12.2024.
//

import Foundation
import CoreData

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

struct DataMainFoodsOnli: DataDelgatForCardsCore{
    var content: [Dish]
    func fetchData() -> [Dish] {
        let mainDishes = content.filter{$0.fromDishCategory.name == "Main Food"}
        print(mainDishes)
        return mainDishes
    }
}

struct DataDrinksOnli: DataDelgatForCardsCore{
    var content: [Dish]
    func fetchData() -> [Dish] {
        let drinks = content.filter{$0.fromDishCategory.name == "Drinks"}
        print(drinks)
        return drinks
    }
}

struct DataDessertsOnli: DataDelgatForCardsCore{
    var content: [Dish]
    func fetchData() -> [Dish] {
        let desserts = content.filter{$0.fromDishCategory.name == "Desserts"}
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
    
    let DishInfoForSrcreen: Dish
    func fetchData() -> Dish {
        return DishInfoForSrcreen
    }
}

func FilterForFoodCore(_ dishes: [Dish], _ maxPrice: Double) -> [Dish]{
    print(dishes)
    return dishes.filter{ $0.price <= maxPrice }
}

