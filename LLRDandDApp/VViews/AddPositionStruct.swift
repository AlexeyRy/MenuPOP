//
//  AddPositionStruct.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 22.12.2024.
//

import Foundation
import CoreData

protocol DataProcessingProtocol{
    func addPosition(name: String, price: Double, ingridients: String, peculiarity: String, isPeculiarity: String, category: DishCategory)
    func deletePosition(_ dish: Dish)
}

class DataProcessing: ObservableObject, DataProcessingProtocol{
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.viewContext = context
    }
    
    func addPosition(name: String = "Unknown", price: Double = 6.66,
                     ingridients: String = "", peculiarity: String = "",
                     isPeculiarity: String = "", category: DishCategory){
        
        let newDish = Dish(context: viewContext)
        newDish.name = name
        newDish.price = price
        newDish.ingridiens = ingridients
        newDish.peculiarity = peculiarity
        newDish.isPeculiarity = peculiarity
        newDish.id = UUID()
        newDish.fromDishCategory = category
        print("Добавил новую позицию меню \(String(describing: newDish.name))")
        saveContext()
    }
    
    func deletePosition(_ dish: Dish){
        viewContext.delete(dish)
        saveContext()
    }
    
    private func saveContext() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            print("Ошибка сохранения контекста: \(error)")
        }
    }
}
