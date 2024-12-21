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
    @StateObject private var dataProcessor: DataProcessor
    @StateObject private var dataModel: DishDataModel
       
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
        _dataModel = StateObject(wrappedValue: dataModel)
        _dataProcessor = StateObject(wrappedValue: DataProcessor(fetcher: dataModel))
    }
    

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(themeManger)
                .environmentObject(categoryManager)
                .environmentObject(dataModel)
                .environmentObject(dataProcessor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
