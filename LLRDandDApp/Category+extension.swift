//
//  Category+extension.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 15.12.2024.
//

import Foundation
import CoreData

@objc(DishCategory)
public class DishCategory: NSManagedObject{
    @NSManaged var name: String
}

