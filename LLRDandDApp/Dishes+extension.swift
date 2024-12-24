//
//  Dishes+extension.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 15.12.2024.
//

import Foundation
import CoreData
import SwiftUI


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@objc(Dish)
public class Dish: NSManagedObject{
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var peculiarity: String?
    @NSManaged public var ingridiens: String?
    @NSManaged public var isPeculiarity: String?
    @NSManaged public var id: UUID
    
    @NSManaged public var fromDishCategory: DishCategory
}

extension Dish{
    class func buildDishes(_ viewContext:NSManagedObjectContext){
        
        let mainFood = DishCategory(context: viewContext)
        mainFood.name = "Main Food"
        
        let drinks = DishCategory(context: viewContext)
        drinks.name = "Drinks"
        
        let desserts = DishCategory(context: viewContext)
        desserts.name = "Desserts"
         
        
        let friedChicken = Dish(context: viewContext)
        friedChicken.name = "Fried Chicken"
        friedChicken.price = 6.66
        friedChicken.ingridiens = "Chicken, oil, salt"
        friedChicken.peculiarity = "Type of Dish"
        friedChicken.isPeculiarity = "Hot"
        friedChicken.id = UUID()
        friedChicken.fromDishCategory = mainFood
        
        let friedChicken2 = Dish(context: viewContext)
        friedChicken2.name = "Super Pasta"
        friedChicken2.price = 9.99
        friedChicken2.ingridiens = "Chicken, oil, salt"
        friedChicken2.peculiarity = "Type of Dish"
        friedChicken2.isPeculiarity = "Cold"
        friedChicken2.id = UUID()
        friedChicken2.fromDishCategory = mainFood
        
        let friedChicken3 = Dish(context: viewContext)
        friedChicken3.name = "Fried"
        friedChicken3.price = 6
        friedChicken3.ingridiens = "Chicken, oil, salt"
        friedChicken3.peculiarity = "Type of Dish"
        friedChicken3.isPeculiarity = "Hot"
        friedChicken3.id = UUID()
        friedChicken3.fromDishCategory = mainFood
        
        let friedChicken4 = Dish(context: viewContext)
        friedChicken4.name = "Chicken"
        friedChicken4.price = 6.66
        friedChicken4.ingridiens = "Chicken, oil, salt"
        friedChicken4.peculiarity = "Type of Dish"
        friedChicken4.isPeculiarity = "Hot"
        friedChicken4.id = UUID()
        friedChicken4.fromDishCategory = mainFood
        
        let friedChicken5 = Dish(context: viewContext)
        friedChicken5.name = "Friken"
        friedChicken5.price = 9
        friedChicken5.ingridiens = "Chicken, oil, salt"
        friedChicken5.peculiarity = "Type of Dish"
        friedChicken5.isPeculiarity = "Hot"
        friedChicken5.id = UUID()
        friedChicken5.fromDishCategory = mainFood
        
        
        let marrrgarita = Dish(context: viewContext)
        marrrgarita.name = "Marrgarita"
        marrrgarita.price = 10.99
        marrrgarita.ingridiens = "olivki, margarita"
        marrrgarita.peculiarity = "Availability of alcohol"
        marrrgarita.isPeculiarity = "Yes"
        marrrgarita.id = UUID()
        marrrgarita.fromDishCategory = drinks
        let marrrgarita2 = Dish(context: viewContext)
        marrrgarita2.name = "Magarita"
        marrrgarita2.price = 10.99
        marrrgarita2.ingridiens = "olivki, margarita"
        marrrgarita2.peculiarity = "Availability of alcohol"
        marrrgarita2.isPeculiarity = "Yes"
        marrrgarita2.id = UUID()
        marrrgarita2.fromDishCategory = drinks
        
        let marrrgarita3 = Dish(context: viewContext)
        marrrgarita3.name = "Marita"
        marrrgarita3.price = 10.99
        marrrgarita3.ingridiens = "olivki, margarita"
        marrrgarita3.peculiarity = "Availability of alcohol"
        marrrgarita3.isPeculiarity = "Yes"
        marrrgarita3.id = UUID()
        marrrgarita3.fromDishCategory = drinks
        
        let marrrgarita4 = Dish(context: viewContext)
        marrrgarita4.name = "Mata"
        marrrgarita4.price = 10.99
        marrrgarita4.ingridiens = "olivki, margarita"
        marrrgarita4.peculiarity = "Availability of alcohol"
        marrrgarita4.isPeculiarity = "Yes"
        marrrgarita4.id = UUID()
        marrrgarita4.fromDishCategory = drinks
        
        let marrrgarita5 = Dish(context: viewContext)
        marrrgarita5.name = "Marria"
        marrrgarita5.price = 10.99
        marrrgarita5.ingridiens = "olivki, margarita"
        marrrgarita5.peculiarity = "Availability of alcohol"
        marrrgarita5.isPeculiarity = "Yes"
        marrrgarita5.id = UUID()
        marrrgarita5.fromDishCategory = drinks
        
        let affogato = Dish(context: viewContext)
        affogato.name = "Affogato"
        affogato.price = 4.50
        affogato.ingridiens = "IDK"
        affogato.peculiarity = "With Sugar"
        affogato.isPeculiarity = "Yes"
        affogato.id = UUID()
        affogato.fromDishCategory = desserts
        
        let affogato2 = Dish(context: viewContext)
        affogato2.name = "Affogato"
        affogato2.price = 4.50
        affogato2.ingridiens = "IDK"
        affogato2.peculiarity = "With Sugar"
        affogato2.isPeculiarity = "Yes"
        affogato2.id = UUID()
        affogato2.fromDishCategory = desserts
        
        let affogato3 = Dish(context: viewContext)
        affogato3.name = "Affogato"
        affogato3.price = 4.50
        affogato3.ingridiens = "IDK"
        affogato3.peculiarity = "With Sugar"
        affogato3.isPeculiarity = "Yes"
        affogato3.id = UUID()
        affogato3.fromDishCategory = desserts
        
        let affogato4 = Dish(context: viewContext)
        affogato4.name = "Affogato"
        affogato4.price = 4.50
        affogato4.ingridiens = "IDK"
        affogato4.peculiarity = "With Sugar"
        affogato4.isPeculiarity = "Yes"
        affogato4.id = UUID()
        affogato4.fromDishCategory = desserts
        
        
        print("Сохраняем данные")
        do {
            try viewContext.save()
            print("Данные успешно сохранены!")
        } catch {
            print("Ошибка при сохранении данных: \(error.localizedDescription)")
        }
    }
}
