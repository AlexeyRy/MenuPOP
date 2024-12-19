//
//  Protocols.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import Foundation
import SwiftUI

protocol DataDelegate{
    associatedtype DataType
    func fetchData(content: DataType) -> DataType
}

protocol DataDelegateForScreen{
    associatedtype DataType
    func fetchData() -> DataType
}

// Обёртка для экзистенциального типа
protocol DataDelegatForTopBarOnli{
    func fetchData() -> DataStructForTopBar
}

//struct AnyDataDelegateForScreen<T>: DataDelegateForScreen {
//    private let _fetchData: () -> T

//    init<D: DataDelegateForScreen>(_ dataDelegate: D) where D.DataType == T {
//        self._fetchData = dataDelegate.fetchData
//    }

//    func fetchData() -> T {
//        _fetchData()
//    }
//}
// Чтобы изменять состояние верхнего топ бара в моменте, мы соединяем передачу данным с конкретным скрином в роутере. Но делаем это не на прямую я через обёртку, которая находится в протоколе. Обёртка в это случае нужна для того, что работать с ассоциальным тип Data прокола. Поэтому мы создаём обёртку, которая так или иначе меняет тип передоваемой даты. Но при этом открывая его так как топ бар ждёт на ход данные стринга


protocol DataDelgatForCardsCore{
    func fetchData() -> [Dish]
}


protocol DataDelgatForDishInfo{
    func fetchData() -> Dish
}

protocol DisplayableDelegate{
    associatedtype Content
    associatedtype ViewType: View
    func BuildView(content: Content) -> ViewType
}

protocol DisplayableDelegateMulti{
    associatedtype Content
    associatedtype Content2
    associatedtype ViewType: View
    func BuildView(cardContent: Content, content: Content2) -> ViewType
}

protocol RouterProtocol{
    func navigate(to destination: Screen)
    func doNothing()
}
