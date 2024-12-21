//
//  CustomStyle.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 10.12.2024.
//

import Foundation
import SwiftUI

// Здесь создаём кастомное отображение кнопок, через встроенный протокол ViewModifier

struct CustomStyleModifierSmallBatton: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 30)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(themeManager.isDarkMod == true ? Color.gray : Color.grayForObjects, lineWidth: 4) // Настраиваем контур
            )
    }
}

struct CustomStyleModifierForCofermButton: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .background(themeManager.isDarkMod == true ? .gray : .grayForObjects)
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


struct CustomModStyleForObjects: ViewModifier{
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View{
        content
            .background(themeManager.isDarkMod == true ? .gray : .grayForObjects)
    }
}

struct CustomModStyleForChooseButtonFT: ViewModifier{
    @EnvironmentObject var themeManager: ThemeManager
    var isButtonChoosed: Bool

    
    func body(content: Content) -> some View{
        content
            .background(isButtonChoosed == true ? .white : (themeManager.isDarkMod == true ? .gray : .grayForObjects))
            .foregroundColor(isButtonChoosed == true ? .black: .white)
    }
}


// передаём функцию при вызове которой будет возвращаться нужные стили
extension View {
    func customBackgroundForObjects() -> some View{
        self.modifier(CustomModStyleForObjects())
    }
    func customButtonStyle() -> some View{
        self.modifier(CustomStyleModifierSmallBatton())
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
    func customStylrForChoosedButton(_ isButtonChoosed: Bool) -> some View{
        self.modifier(CustomModStyleForChooseButtonFT(isButtonChoosed: isButtonChoosed))
    }
}
