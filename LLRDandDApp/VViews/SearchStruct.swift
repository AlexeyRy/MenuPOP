//
//  SearchStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 21.12.2024.
//

import Foundation
import SwiftUI
import CoreData

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Создаём структуру в которой будем собирать дату для страницы и структуру постороение визуала
struct SearchField<Data: DataDelegateForScreen, Delegate: DisplayableDelegate>: View where Data.DataType == Delegate.Content{
    
    var dataDelegat: Data
    var displaybleDelegate: Delegate
    
    var body: some View{
        let data = dataDelegat.fetchData()
        displaybleDelegate.BuildView(content: data)
    }
}

// Структура отображения обьекта поисковой страницы
struct SearchFiledDisplayable: DisplayableDelegate{
    @ObservedObject var viewModel: DataSH
    
    func BuildView(content: String) -> some View {
        
        ZStack{
            
            TextField(content, text: $viewModel.searchText)
                                .padding()
                                .customBackgroundForObjects()
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                
        }
        .frame(width: 370, height: 30)
        .customBack()
        .cornerRadius(5)
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

