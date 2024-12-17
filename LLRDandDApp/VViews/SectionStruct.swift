//
//  SectionStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 11.12.2024.
//

import Foundation
import SwiftUI
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///Реализуем Секционные карты и распределение обьектов
// Структура, которая собирает отображения из полученных делегатов. В нашем кейсе их три. Делегат отображения, делегат даты для карт, делегат контента самой секции

struct Section<Delegate: DisplayableDelegateMulti, Data: DataDelegateForScreen>: View where Delegate.Content == [Dish], Delegate.Content2 == Data.DataType{
    let dataDelegatFoSection: Data
    let dataDelegatForCards: DataDelgatForCardsCore
    
    let displayDelegate: Delegate
    
    var body: some View{
        let dataForSection = dataDelegatFoSection.fetchData()
        let dataForCards = dataDelegatForCards.fetchData()
        displayDelegate.BuildView(cardContent: dataForCards, content: dataForSection)
    }
}

// Создаём структуру, которая собственно говоря и создаёт отображение секций и карточек в ней
// В этой структуре через ViewMidel мы подсасываем данные конкретной карточки после нажатия на неё, потом передаём в необходимое для отображение место


struct SectionDisplay: DisplayableDelegateMulti{
    @ObservedObject var viewModel: SectionViewMod
    
    func BuildView(cardContent: [Dish], content: String) -> some View {
        ZStack{
            VStack(alignment: .leading){
                Text(content)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    .customText()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]){
                    ForEach(cardContent, id: \.id){item in
                        
                        Button(action:{
                            viewModel.currentDish = item
                            viewModel.tapOnInfo()
                        } , label: {
                            ZStack{
                                Text(item.name ?? "Unknown")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                
                                    
                                }.frame(width: 100, height: 100)
                                    .background(.gray)
                                    .cornerRadius(10)
                                    .padding(.bottom, 20)
                            
                        })
                        
                    }
                }
            }// .padding(.leading, 20)
                
        }.customBack()
    }
}

// Модель функций страницы. В ней мы создаём два обьекта. Это биндиговую переменную для подсасывания даты для последующей передачи в навигации и функционал переключения между экранами
final class SectionViewMod: ObservableObject{
    
    @Binding var currentDish: Dish?
    let tapOnInfo: () -> Void
    
    init(tapOnInfo: @escaping () -> Void,
         currentDish: Binding<Dish?>) {
        self.tapOnInfo = tapOnInfo
        self._currentDish = currentDish
    }
    //func buildView(content: Dishes) -> some View{
        
    //}
}

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

