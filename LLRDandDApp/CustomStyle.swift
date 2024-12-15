//
//  CustomStyle.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 10.12.2024.
//

import Foundation
import SwiftUI

// Здесь создаём кастомное отображение кнопок, через встроенный протокол ViewModifier

struct CustomStyleModifierChoosed: ViewModifier {
    @EnvironmentObject var category: Router
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 30)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 4) // Настраиваем контур
            )
    }
}

struct CustomStyleModifierForCofermButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .background(.gray)
            .cornerRadius(10)
    }
}


struct CustomLightDarkModStyleForBack: ViewModifier{
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View{
        content
            .background(themeManager.isDarkMod == true ? .darkGray: .lightBlue)
    }
}


struct CustomLightDarkModStyleForText: ViewModifier{
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View{
        content
            .foregroundColor(themeManager.isDarkMod == true ? .white : .black)
    }
}


// передаём функцию при вызове которой будет возвращаться нужные стили
extension View {
    func customButtonStyle() -> some View{
        self.modifier(CustomStyleModifierChoosed())
    }
    func customBack() -> some View{
        self.modifier(CustomLightDarkModStyleForBack())
    }
    func customText() -> some View{
        self.modifier(CustomLightDarkModStyleForText())
    }
    func customBackButtonStyle() -> some View{
        self.modifier(CustomStyleModifierForCofermButton())
    }
}
