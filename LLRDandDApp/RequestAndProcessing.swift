//
//  RequestAndProcessing.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 21.12.2024.
//

import CoreData
import SwiftUI
import Combine

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Класс занимающийся только запросами из базы данных
class DishDataModel: ObservableObject{
    @Published var dishes: [Dish] = []
    
    init(context: NSManagedObjectContext) {
        fetchDishes(context: context)
    }
    
    func fetchDishes(context: NSManagedObjectContext){
        let request: NSFetchRequest<Dish> = Dish.fetchRequest() as! NSFetchRequest<Dish>
        request.predicate = NSPredicate(value: true)

        do{
            dishes = try context.fetch(request)
        }catch{
            print("Error fetching dishes: \(error)")
        }
    }
    
    
}

// Класс занимающийся только фильттрацией и работай над кэшированными данными из базы данных
class DataProcessor: ObservableObject{
    @Published var filteredDishes: [Dish] = []
    @Published var searchText: String = ""
    @Published var maxPrice: Double = 60.00
    
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var allDishes: [Dish] = []
    
    init(fetcher: DishDataModel) {
            // Подписываемся на изменения dishes
            fetcher.$dishes
                .sink { [weak self] dishes in
                    self?.allDishes = dishes
                    self?.updateFilters() // Обновляем фильтры при изменении данных
                }
                .store(in: &cancellables)
        }
    
    func updateFilters() {
            filterDishesByName(searchText)
            filterDishesByPrice()
    }
    
    func filterDishesByName(_ searchText: String = ""){
        print("Filtering with text: \(searchText)")
        if searchText.isEmpty {
            filteredDishes = allDishes
        } else {
            filteredDishes = allDishes.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    func filterDishesByPrice(){
        filteredDishes = allDishes.filter { $0.price <= maxPrice }
    }
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

