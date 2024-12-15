//
//  Dishes+extension.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 15.12.2024.
//

import Foundation
import CoreData

@objc(Dish)
public class Dish: NSManagedObject{
    @NSManaged var name: String?
    @NSManaged var price: Double
    @NSManaged var peculiarity: String?
    @NSManaged var ingridiens: [String]?
    @NSManaged var isPeculiarity: String?
    @NSManaged var id: UUID
    @NSManaged var category: DishCategory
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
        friedChicken.ingridiens = ["Chicken", "oil", "salt"]
        friedChicken.peculiarity = "Type of Dish"
        friedChicken.isPeculiarity = "Hot"
        friedChicken.id = UUID()
        friedChicken.category = mainFood
        
        let friedChicken2 = Dish(context: viewContext)
        friedChicken2.name = "Super Pasta"
        friedChicken2.price = 9.99
        friedChicken2.ingridiens = ["Chicken", "oil", "salt"]
        friedChicken2.peculiarity = "Type of Dish"
        friedChicken2.isPeculiarity = "Cold"
        friedChicken2.id = UUID()
        friedChicken.category = mainFood
        
        let friedChicken3 = Dish(context: viewContext)
        friedChicken3.name = "Fried Chicken"
        friedChicken3.price = 6.66
        friedChicken3.ingridiens = ["Chicken", "oil", "salt"]
        friedChicken3.peculiarity = "Type of Dish"
        friedChicken3.isPeculiarity = "Hot"
        friedChicken3.id = UUID()
        friedChicken.category = mainFood
        
        let friedChicken4 = Dish(context: viewContext)
        friedChicken4.name = "Fried Chicken"
        friedChicken4.price = 6.66
        friedChicken4.ingridiens = ["Chicken", "oil", "salt"]
        friedChicken4.peculiarity = "Type of Dish"
        friedChicken4.isPeculiarity = "Hot"
        friedChicken4.id = UUID()
        friedChicken.category = mainFood
        
        let friedChicken5 = Dish(context: viewContext)
        friedChicken5.name = "Fried Chicken"
        friedChicken5.price = 6.66
        friedChicken5.ingridiens = ["Chicken", "oil", "salt"]
        friedChicken5.peculiarity = "Type of Dish"
        friedChicken5.isPeculiarity = "Hot"
        friedChicken5.id = UUID()
        friedChicken.category = mainFood
    }
}
