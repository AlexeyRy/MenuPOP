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
                                if !viewModel.isLongTapActice {
                                    UIApplication.shared.endEditing(true)
                                    viewModel.showDeleteOption = false
                                    viewModel.currentDish = item
                                    viewModel.tapOnInfo()
                                }else{
                                    if viewModel.confirmDelete == true && viewModel.currentDish == item{
                                        viewModel.dataProcessing.deletePosition(viewModel.currentDish ?? item)
                                        viewModel.confirmDelete = false
                                        viewModel.isLongTapActice = false
                                    }else{
                                        viewModel.confirmDelete = true
                                    }
                                }
                            }, label: {
                                ZStack{
                                    if viewModel.isLongTapActice == true{
                                        if viewModel.currentDish == item{
                                            Image(systemName: "minus.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.red)
                                                .frame(width: 100, height: 100)
                                                .customBackgroundForObjects()
                                                .cornerRadius(10)
                                        }else{
                                            Text(item.name ?? "Unknown")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .frame(width: 100, height: 100)
                                                .customBackgroundForObjects()
                                                .cornerRadius(10)
                                        }
                                    }else{
                                        Text(item.name ?? "Unknown")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .frame(width: 100, height: 100)
                                            .customBackgroundForObjects()
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                
                            ).simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded{ _ in
                                        withAnimation {
                                            DispatchQueue.main.async {
                                                viewModel.isLongTapActice = true
                                                viewModel.currentDish = item
                                                print("isLongTap: \(viewModel.isLongTapActice)")
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            viewModel.isLongTapActice = false
                                            viewModel.confirmDelete = false
                                            print("isLongTapIn 1.5 seconds: \(viewModel.isLongTapActice)")
                                        }
                                    }
                            )
                        
                    }
                }
            }// .padding(.leading, 20)
                
        }.customBack()
    }
}

// Модель функций страницы. В ней мы создаём два обьекта. Это биндиговую переменную для подсасывания даты для последующей передачи в навигации и функционал переключения между экранами
final class SectionViewMod: ObservableObject{
    @Published var confirmDelete: Bool = false
    @Binding var isLongTapActice: Bool
    @Binding var showDeleteOption: Bool
    @Binding var currentDish: Dish?
    
    var tapOnInfo: () -> Void
    var dataProcessing: DataProcessing
    
    init(tapOnInfo: @escaping () -> Void,
         dataProcessing: DataProcessing,
         isLongTapActive: Binding<Bool>,
         showDeleteOption: Binding<Bool>,
         currentDish: Binding<Dish?>
    ) {
        self._isLongTapActice = isLongTapActive
        self._showDeleteOption = showDeleteOption
        self._currentDish = currentDish
        self.tapOnInfo = tapOnInfo
        self.dataProcessing = dataProcessing
    }
    //func buildView(content: Dishes) -> some View{
        
    //}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
