//
//  ContentView.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    /*
    @FetchRequest(entity: Dish.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)]) private var dishItems: FetchedResults<Dish>
     */
    
    @StateObject var viewModel: DishesViewModel
    @StateObject var dataModel: DishDataModel
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var categotyManager: CategoryManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var maxPrice: Double = 60
    @State var currentDish: Dish?
    @State var searchText: String = ""
    @State private var filteredDishes: [Dish] = []
    
    init(context: NSManagedObjectContext) {
        // Инициализация viewModel2 с передачей viewContext
        _dataModel = StateObject(wrappedValue: DishDataModel(context: context))
        _viewModel = StateObject(wrappedValue: DishesViewModel(fetchedResults: nil))
        
    }
    
    var body: some View {

        let contentViewModel = ContentViewModel(router: router,
                                                categotyManager: categotyManager,
                                                themeManager: themeManager,
                                                maxPrice: $maxPrice,
                                                currentDish: $currentDish)
        
        
                VStack {
                    TopBar(dataDelegate: router.currentTopBarData,
                           displayableDelegate: TopBarDisplayableDelegate(viewModel: contentViewModel.topBarViewModel))
                    
                    TextField("Поиск по меню...", text: $searchText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .onChange(of: searchText) { _ in
                                            if searchText.isEmpty {
                                                        filteredDishes = dataModel.dishes
                                            } else {
                                                        filteredDishes = contentViewModel.filterDishesByName(dataModel.dishes, byText: searchText)
                                            }
                                        }

                    NavigationView{
                        ZStack{
                            NavigationLink(
                                destination: Settings(
                                    dataDelgate: SettingsData(),
                                    displayDelegate: SettingsDisplay(viewModel: contentViewModel.settingsViewModel)),
                                tag: .settingsScreen,
                                selection: $router.currentScreen,
                                label: {})
                            NavigationLink(
                                destination: Filter(
                                    dataDelegate: FilterData(),
                                    displayDelegate: FilterDisplay(
                                        viewModel: contentViewModel.filterViewModel
                                    )
                                ).environmentObject(router),
                                tag: .filtreationScreen,
                                selection: $router.currentScreen,
                                label: {})
                            
                            NavigationLink(destination: Info(
                                dataDelegatFoSection: ContentForInfoPage(),
                                dataDelegatForCards: DishCardData(DishInfoForSrcreen: currentDish ?? Dish()),
                                displayDelegate: InfoDisplay(viewModel: contentViewModel.informationViewModel)
                            ),
                                           tag: .information,
                                           selection: $router.currentScreen,
                                           label: {})
                            
                            
                            
                            ScrollView{
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .mainFood{
                                    Section(dataDelegatFoSection: SectionMainStructData(),
                                            dataDelegatForCards: DataMainFoodsOnli(
                                                content: filteredDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: contentViewModel.sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .drinks{
                                    Section(dataDelegatFoSection: SectionDkinksStructData(),
                                            dataDelegatForCards: DataDrinksOnli(
                                                content: filteredDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: contentViewModel.sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .desserts{
                                    Section(dataDelegatFoSection: SectionDessertStructData(),
                                            dataDelegatForCards: DataDessertsOnli(
                                                content: filteredDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: contentViewModel.sectionViewModel)
                                    )
                                }
                            }.gesture(DragGesture().onChanged { _ in
                                UIApplication.shared.endEditing(true) // Закрытие клавиатуры при прокрутке
                            })
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            .customBack()
                    }
                    Spacer()
                }.onAppear {dataModel.fetchDishes()
                            filteredDishes = contentViewModel.filterDishesByPrice(dataModel.dishes, by: maxPrice)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .customBack()
    }
}

class ContentViewModel: ObservableObject{
    
    var topBarViewModel: TopBarViewModel
    var settingsViewModel: SettingsViewMod
    var filterViewModel: FilterViewModel
    var sectionViewModel: SectionViewMod
    var informationViewModel: InformationViewModel
    
    init(router: Router, categotyManager: CategoryManager, themeManager: ThemeManager, maxPrice: Binding<Double>, currentDish: Binding<Dish?>) {
        
        // Инициализация ViewModels с переданными зависимостями
        self.topBarViewModel = TopBarViewModel(
            onSettingsTap: {router.navigate(to: .settingsScreen)},
            onFilterTap: {router.navigate(to: .filtreationScreen)}
        )
        
        self.settingsViewModel = SettingsViewMod(
            changeTheme: {themeManager.toggleTheme()},
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
        self.filterViewModel = FilterViewModel(
            isButtonChoosed: categotyManager.currentDishesCategory ?? .all,
            maxPrice: maxPrice,
            chooseCategoryOfDishesAll: {categotyManager.changeCategory(to: .all)},
            chooseCategoryOfDishesMain: {categotyManager.changeCategory(to: .mainFood)},
            chooseCategoryOfDishesDrinks: {categotyManager.changeCategory(to: .drinks)},
            chooseCategoryOfDishesDesserts: {categotyManager.changeCategory(to: .desserts)},
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
        self.sectionViewModel = SectionViewMod(
            tapOnInfo: {router.navigate(to: .information)},
            currentDish: currentDish
        )
        
        self.informationViewModel = InformationViewModel(
            backToMain: {router.navigate(to: .homeScreen)}
        )
    }
    
    // Функции фильтрации
    func filterDishesByPrice(_ dishes: [Dish], by maxPrice: Double) -> [Dish] {
        return dishes.filter { $0.price <= maxPrice }
    }
    
    func filterDishesByName(_ dishes: [Dish], byText searchingText: String = "") -> [Dish] {
        if searchingText.isEmpty {
            return dishes
        } else {
            return dishes.filter { $0.name?.localizedCaseInsensitiveContains(searchingText) ?? false }
        }
    }
}
class DishDataModel: ObservableObject{
    @Published var dishes: [Dish] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchDishes()
    }
    
    func fetchDishes(){
        let request: NSFetchRequest<Dish> = Dish.fetchRequest() as! NSFetchRequest<Dish>
        request.predicate = NSPredicate(value: true)

        do{
            dishes = try context.fetch(request)
        }catch{
            print("Error fetching dishes: \(error)")
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.filter { $0.isKeyWindow }.first?.endEditing(force)
    }
}

/*
 #Preview {
 let persistenceController = PersistenceController.shared
 
 ContentView()
 .environmentObject(Router())
 .environmentObject(ThemeManager())
 .environment(\.managedObjectContext, persistenceController.container.viewContext)
 }
*/
 
