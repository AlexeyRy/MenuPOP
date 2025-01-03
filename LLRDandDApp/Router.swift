//
//  Router.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 8.12.2024.
//

import Foundation

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// создаём роутер, который отвечает за смену и экранов
final class Router: ObservableObject{
    @Published var currentScreen: Screen? = .homeScreen
    @Published var currentTopBarData: DataDelegatForTopBarOnli = DataForTopBarMenu()
    
    // Чтобы изменять состояние верхнего топ бара в моменте, мы соединяем передачу данным с конкретным скрином в роутере. Но делаем это не на прямую я через обёртку, которая находится в протоколе. Обёртка в это случае нужна для того, что работать с ассоциальным тип Data прокола. Поэтому мы создаём обёртку, которая так или иначе меняет тип передоваемой даты. Но при этом открывая его так как топ бар ждёт на ход данные стринга
    // Апдейт. Сделал протокол только для стринга, чтобы передавать дату без ебли
    
    func navigate(to destination: Screen = .homeScreen) {
        self.currentScreen = destination
        switch destination.self {
        case .homeScreen:
            currentTopBarData = DataForTopBarMenu()
        case .settingsScreen:
            currentTopBarData = DataForTopBarSettings()
        case .filtreationScreen:
            currentTopBarData = DataForTopBarFiltration()
        case .information:
            currentTopBarData = DataForTopBarInfo()
        case .addPosition:
            currentTopBarData = DataForTopBarAddPosition()
        }
    }
}

// Список скринов для роутера
enum Screen{
    case homeScreen
    case filtreationScreen
    case settingsScreen
    case information
    case addPosition
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Класс отвечающий за выбранную категорию
final class CategoryManager: ObservableObject{
    @Published var currentDishesCategory: Category? = .all
    @Published var nameOFCurrentCategory: String = "All"
    
    func changeCategory(to category: Category){
        self.currentDishesCategory = category
        switch category.self{
        case .all:
            nameOFCurrentCategory = "All"
        case .mainFood:
            nameOFCurrentCategory = "Main Food"
        case .drinks:
            nameOFCurrentCategory = "Drinks"
        case .desserts:
            nameOFCurrentCategory = "Desserts"
        }
    }
}

enum Category{
    case all
    case mainFood
    case drinks
    case desserts
}

final class ThemeManager: ObservableObject{
    @Published var isDarkMod = true
    
    func toggleTheme(){
        isDarkMod.toggle()
    }
}

