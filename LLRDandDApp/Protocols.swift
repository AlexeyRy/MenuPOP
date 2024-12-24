//
//  Protocols.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import Foundation
import SwiftUI

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
