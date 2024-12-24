//
//  DishInformationStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 21.12.2024.
//

import Foundation
import SwiftUI

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Создаём информационную структуру
///

// Структура что общается с тремя делегатамами, делегат контента на самой странице, делегат отображения и делагат что даёт дату из секции для коректоного отображения данных конкретной карты, при использовании роутера
struct Info<Delegate: DisplayableDelegateMulti, Data: DataDelegateForScreen>: View where Delegate.Content == Dish, Delegate.Content2 == Data.DataType{
    
    let dataDelegatFoSection: Data
    let dataDelegatForCards: DataDelgatForDishInfo
    
    let displayDelegate: Delegate
    
    var body: some View{
        let dataForSection = dataDelegatFoSection.fetchData()
        let dataForCards = dataDelegatForCards.fetchData()
        displayDelegate.BuildView(cardContent: dataForCards, content: dataForSection)
    }
}


// Структура отображения каждой из страниц
struct InfoDisplay: DisplayableDelegateMulti{
    @ObservedObject var viewModel: InformationViewModel
    
    func BuildView(cardContent: Dish, content: DataForInfoScreen) -> some View {
        // let ingridientsList = Combining(cardContent.ingridiens ?? [""])
        
        return ZStack{
            VStack{
                Image(content.nameForPicture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading){
                    Text("Name: \(cardContent.name ?? "Unknown")")
                    Text("Price: \(String(format: "%.2f", cardContent.price))$")
                    Text("\(cardContent.peculiarity ?? "Unknown"): \(cardContent.isPeculiarity ?? "Unknown")")
                    Text("ingredients: \(cardContent.ingridiens ?? "Unknown")")
                }.padding()
                    .fontWeight(.bold)
                    .customText()
                
                Button(action: viewModel.backToMain){
                    Text("Back To Main")
                    .font(.title3)
                    .customBackButtonStyle()
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
            .customBack()
    }
}

// Поведение при нажатии кнопки возвращения
final class InformationViewModel: ObservableObject{
    let backToMain: () -> Void
    
    init(backToMain: @escaping () -> Void) {
        self.backToMain = backToMain
    }
}


