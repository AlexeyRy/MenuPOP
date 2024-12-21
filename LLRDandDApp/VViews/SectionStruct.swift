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
                            UIApplication.shared.endEditing(true)
                            viewModel.currentDish = item
                            viewModel.tapOnInfo()
                        } , label: {
                            ZStack{
                                Text(item.name ?? "Unknown")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                
                                    
                                }.frame(width: 100, height: 100)
                                    .customBackgroundForObjects()
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
