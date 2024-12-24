//
//  LLRDandDAppApp.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import SwiftUI

@main
struct LLRDandDAppApp: App {
    
    @StateObject private var router = Router()
    @StateObject private var themeManger = ThemeManager()
    @StateObject private var categoryManager = CategoryManager()
    @StateObject private var dataSH: DataSH
    @StateObject private var dataModel: DishDataModel
    @StateObject private var dataProcessing: DataProcessing
       
    let persistenceController = PersistenceController.shared
    
    init(){ // Проверяем на наличие обьектов в базе, если база пустаю создаём стартовые объекты
        let context = persistenceController.container.viewContext
        
        do{
            let result = try context.fetch(Dish.fetchRequest())
            if result.isEmpty{
                Dish.buildDishes(persistenceController.container.viewContext)
            }
        }catch{
            print("Ошибка при загрузке данных \(error.localizedDescription)")
        }
        
        let dataModel = DishDataModel(context: context)
        _dataProcessing = StateObject(wrappedValue: DataProcessing(context: context))
        _dataModel = StateObject(wrappedValue: dataModel)
        _dataSH = StateObject(wrappedValue: DataSH(fetcher: dataModel))
    }
    

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(themeManger)
                .environmentObject(categoryManager)
                .environmentObject(dataModel)
                .environmentObject(dataSH)
                .environmentObject(dataProcessing)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
