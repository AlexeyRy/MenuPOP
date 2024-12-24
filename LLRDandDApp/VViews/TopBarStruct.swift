//
//  TopBarStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import Foundation
import SwiftUI

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///Реализовываю Верхнюю менюшку
// Создаём структура, которая на вход получает два протокола (делегата): данные страницы, отображение данных на странице
struct TopBar <Delegate: DisplayableDelegate>: View where Delegate.Content == DataStructForTopBar{ // Так как они ассоциативного типа, мы явно говорим структуре, что ти п данных который мы передаём в ассоциативный контент является стринговой
    
    let dataDelegate: DataDelegatForTopBarOnli  // Присваеваем пременной протокол работы с данными
    let displayableDelegate: Delegate // Присваеваем переменной протокол работы с отображением
    
    var body: some View{
        let dataForTopBar = dataDelegate.fetchData() // вызываем функцию, которая возвращает данные для страницы
        displayableDelegate.BuildView(content: dataForTopBar) // вызываем функцию обработки страницы и данных
    }
}

// Создаём рендер для верхнего бара
struct TopBarDisplayableDelegate: DisplayableDelegate{
    
    @ObservedObject var viewModel: TopBarViewModel // передаём реализацию на class в котором реализуется логика
    
    func BuildView(content: DataStructForTopBar) -> some View { // функция, которая возвращает рендер Топбара
        
        HStack{
            Text(content.title)   // Данные для отображения передаются сюда
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Spacer()
            Button(action: viewModel.onSettingsTap){    // создаём кнопку с неявной обработкой события
                Image(systemName: content.settingsImage)
                    .foregroundColor(.white)
            }.padding()
            Button(action: viewModel.onFilterTap){
                Image(systemName: content.filterImage)
                    .foregroundColor(.white)
            }.padding(.trailing, 10)
        }.padding()
    .padding(.top, 40)
    .padding(.bottom, 20)
    .frame(width: 400, height: 120)
    .customBackgroundForObjects()
    .cornerRadius(20)
        
    }
}

final class TopBarViewModel: ObservableObject{
    let onSettingsTap: () -> Void
    let onFilterTap: () -> Void
    
    
    init(onSettingsTap: @escaping () -> Void, onFilterTap: @escaping () -> Void) {
        self.onSettingsTap = onSettingsTap
        self.onFilterTap = onFilterTap
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
