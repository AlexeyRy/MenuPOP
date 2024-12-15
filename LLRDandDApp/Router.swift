//
//  Router.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 8.12.2024.
//

import Foundation


// создаём роутер, который на данный момент отвечает за мену и экранов и категории
final class Router: ObservableObject{
    @Published var currentScreen: Screen? = .homeScreen
    @Published var dishesCategory: Category = .all
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
                }
    }
    
    // Функция для смены категории
    func changeCategory(choose category: Category){
        self.dishesCategory = category
        print(category)
    }
    func doNothing() {
        print("Пшёл")
    }
}

final class ThemeManager: ObservableObject{
    @Published var isDarkMod = true
    
    func toggleTheme(){
        isDarkMod.toggle()
    }
}

enum Screen{
    case homeScreen
    case filtreationScreen
    case settingsScreen
    case information
}
