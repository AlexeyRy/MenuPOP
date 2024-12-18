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
   
    let dishes = DishesViewModel(fetchedResults: nil)
    
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
    }
    

    
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environmentObject(router)
                .environmentObject(themeManger)
                .environmentObject(categoryManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
