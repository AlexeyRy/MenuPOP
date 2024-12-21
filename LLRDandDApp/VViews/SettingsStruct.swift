//
//  SettingsStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 10.12.2024.
//

import Foundation
import SwiftUI

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Реализовывем отображение Меню натроек

struct Settings <Delegate: DisplayableDelegate, Data: DataDelegateForScreen>: View where Delegate.Content == Data.DataType{
    
    let dataDelgate: Data
    let displayDelegate: Delegate
    
    var body: some View{
        let data = dataDelgate.fetchData()
        displayDelegate.BuildView(content: data)
    }
}

struct SettingsDisplay: DisplayableDelegate{
    @ObservedObject var viewModel: SettingsViewMod
    
    func BuildView(content: SettingsDataStruct) -> some View {
        ZStack{
            VStack{
                
                Text(content.mainText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .customText()
                    
                Button(action: viewModel.changeTheme){
                    Text(content.textForButtonTheme)
                }.customButtonStyle()
                    .customBackgroundForObjects()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
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

final class SettingsViewMod: ObservableObject{
    let changeTheme: () -> Void
    let backToMain: () -> Void
    
    init(changeTheme: @escaping () -> Void, backToMain: @escaping () -> Void) {
        self.changeTheme = changeTheme
        self.backToMain = backToMain
    }
}

