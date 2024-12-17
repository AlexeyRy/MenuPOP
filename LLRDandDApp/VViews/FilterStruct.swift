//
//  FilterStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 9.12.2024.
//

import Foundation
import SwiftUI

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///  Реализовываем страницу фильтрации

struct Filter <Delegate: DisplayableDelegate, Data: DataDelegateForScreen>: View where Delegate.Content == Data.DataType{
    
        
    let dataDelegate: Data
    let displayDelegate: Delegate
    
    var body: some View{
        
        let dataForFilter = dataDelegate.fetchData()
        displayDelegate.BuildView(content: dataForFilter)
        
    }
}

// Создаём отображение передавая поведение и дату
struct FilterDisplay: DisplayableDelegate{
    @ObservedObject var viewModel: FilterViewModel // передаём поведение
    //@Binding var isButtonChoosed: Category
    //@Binding var maxPrice: Double
    
    
    func BuildView(content: DataStructForFilter) -> some View{
        ZStack{ // в функции передаём дату используя структуру dataSrtuctForFilter
            VStack(){
                
                Text(content.category) // передаём категорию
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding(.top, 40)
                    .customText()
                
                // Здесь передаём инструкции по обработки в кнопки, так же выгружаем необходиммые названия в кнопки. Так же используем функцию кастомного отображению внизу кнопок и проверки выбранной категории
                VStack(spacing: 10){
                    Button(action: viewModel.chooseCategoryOfDishesAll){
                        Text(content.categoryAll)
                            .customButtonStyle()
                    }
                        .background(viewModel.isButtonChoosed == .all ? .white : .gray)
                        .foregroundColor(viewModel.isButtonChoosed == .all ? .black : .white)
                        .cornerRadius(10)
                        
                    Button(action: viewModel.chooseCategoryOfDishesMain){
                        Text(content.categoryMain)
                            .customButtonStyle()
                    }
                        .background(viewModel.isButtonChoosed == .mainFood ? .white : .gray)
                        .foregroundColor(viewModel.isButtonChoosed == .mainFood ? .black : .white)
                        .cornerRadius(10)
                        
                        
                    Button(action: viewModel.chooseCategoryOfDishesDrinks){
                        Text(content.categoryDrinks)
                            .customButtonStyle()
                    }
                        .background(viewModel.isButtonChoosed == .drinks ? .white : .gray)
                        .foregroundColor(viewModel.isButtonChoosed == .drinks ? .black : .white)
                        .cornerRadius(10)
                        
                    Button(action: viewModel.chooseCategoryOfDishesDesserts){
                        Text(content.categoryDessert)
                            .customButtonStyle()
                    }
                        .background(viewModel.isButtonChoosed == .desserts ? .white : .gray)
                        .foregroundColor(viewModel.isButtonChoosed == .desserts ? .black : .white)
                        .cornerRadius(10)
                        
                }.padding(.bottom, 20)
    
                Text(content.priceSlider)
                    .font(.title2)
                    .fontWeight(.bold)
                    .customText()
                
                Slider(value: $viewModel.maxPrice, in: 0...100, step: 0.1){
                    Text("Max Price")
                        .customText()
                }.frame(width: 300, height: 50)
                Text("Max price: \(viewModel.maxPrice, specifier: "%.2f")")
                    .customText()
                    
                Spacer()
                
                Button(action: viewModel.backToMain){
                    Text(content.textForBackButton)
                        .font(.title3)
                        .customBackButtonStyle()
                }
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
            .customBack()
            
    }
}

// Модель поведения необходимая для окна фильтрации, а именно реализовываем обработку колужера, через смену катеогрий меню в роутере
final class FilterViewModel: ObservableObject{
    
    // под каждый переменную в enum Category передаём кложер, который будет отвечать за смену категории на данную
    @Published var isButtonChoosed: Category
    @Binding var maxPrice: Double
    
    let chooseCategoryOfDishesAll: () -> Void
    let chooseCategoryOfDishesMain: () -> Void
    let chooseCategoryOfDishesDrinks: () -> Void
    let chooseCategoryOfDishesDesserts: () -> Void
    
    //Передаём поведение кнопки для смены роутера
    let backToMain: () -> Void
    
    
    init(isButtonChoosed: Category,
         maxPrice: Binding<Double>,
         chooseCategoryOfDishesAll: @escaping () -> Void,
         chooseCategoryOfDishesMain: @escaping () -> Void,
         chooseCategoryOfDishesDrinks: @escaping () -> Void,
         chooseCategoryOfDishesDesserts: @escaping () -> Void,
         backToMain: @escaping () -> Void) {
        self.isButtonChoosed = isButtonChoosed
        self._maxPrice = maxPrice
        self.chooseCategoryOfDishesAll = chooseCategoryOfDishesAll
        self.chooseCategoryOfDishesMain = chooseCategoryOfDishesMain
        self.chooseCategoryOfDishesDrinks = chooseCategoryOfDishesDrinks
        self.chooseCategoryOfDishesDesserts = chooseCategoryOfDishesDesserts
        self.backToMain = backToMain
    }
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



