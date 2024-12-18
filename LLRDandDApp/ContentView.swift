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
    @StateObject var viewModel2: DishViewModel
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var categotyManager: CategoryManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var maxPrice: Double = 60
    @State var currentDish: Dish?
    
    init(context: NSManagedObjectContext) {
        // Инициализация viewModel2 с передачей viewContext
        _viewModel2 = StateObject(wrappedValue: DishViewModel(context: context))
        _viewModel = StateObject(wrappedValue: DishesViewModel(fetchedResults: nil))
        
    }
    
    var body: some View {

        
        let filteredDishes = viewModel2.filterDishesByPrice(viewModel2.dishes, by: maxPrice)
        //let filterDishes = FilterForFood(allFood, maxPrice)
        // фильтруем карточки по цене
        
        let topBarViewModel = TopBarViewModel(
            onSettingsTap: {router.navigate(to: .settingsScreen)},
            onFilterTap: {router.navigate(to: .filtreationScreen)}
        )// передаём реализацую cluser в переменную через класс TopBarViewModel. В котором реализуется логика работы окна topBar
        
        // Модель поведения страницы
        let settingsViewModel = SettingsViewMod(
            changeTheme: {themeManager.toggleTheme()},
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
        // передаём поведение кнопок в пременную и в последсвии в меню фильтрации. Так же передаём биндинг для изменения прайса, а так же сохздаём переменную, которая ослеживает выбранную категорию для динамического изменения интерфейса в окне фильтрации
        let filterViewModel = FilterViewModel(
            isButtonChoosed: categotyManager.currentDishesCategory ?? .all,
            maxPrice: $maxPrice,
            chooseCategoryOfDishesAll: {categotyManager.changeCategory(to: .all)},
            chooseCategoryOfDishesMain: {categotyManager.changeCategory(to: .mainFood)},
            chooseCategoryOfDishesDrinks: {categotyManager.changeCategory(to: .drinks)},
            chooseCategoryOfDishesDesserts: {categotyManager.changeCategory(to: .desserts)},
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
        // передаём поведение кнопки, а так же биндинг для подсасывания данных
        let sectionViewModel = SectionViewMod(
            tapOnInfo: {router.navigate(to: .information)},
            currentDish: $currentDish
        )
        
        
        // кнопка для возвращения домой
        let informationViewModel = InformationViewModel(
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
                VStack {
                    TopBar(dataDelegate: router.currentTopBarData,
                           displayableDelegate: TopBarDisplayableDelegate(viewModel: topBarViewModel))
                    NavigationView{
                        ZStack{
                            NavigationLink(
                                destination: Settings(
                                    dataDelgate: SettingsData(),
                                    displayDelegate: SettingsDisplay(viewModel: settingsViewModel)),
                                tag: .settingsScreen,
                                selection: $router.currentScreen,
                                label: {})
                            NavigationLink(
                                destination: Filter(
                                    dataDelegate: FilterData(),
                                    displayDelegate: FilterDisplay(
                                        viewModel: filterViewModel
                                    )
                                ).environmentObject(router),
                                tag: .filtreationScreen,
                                selection: $router.currentScreen,
                                label: {})
                            
                            NavigationLink(destination: Info(
                                dataDelegatFoSection: ContentForInfoPage(),
                                dataDelegatForCards: DishCardData(DishInfoForSrcreen: currentDish ?? Dish()),
                                displayDelegate: InfoDisplay(viewModel: informationViewModel)
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
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .drinks{
                                    Section(dataDelegatFoSection: SectionDkinksStructData(),
                                            dataDelegatForCards: DataDrinksOnli(
                                                content: filteredDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .desserts{
                                    Section(dataDelegatFoSection: SectionDessertStructData(),
                                            dataDelegatForCards: DataDessertsOnli(
                                                content: filteredDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                            }
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            .customBack()
                    }
                    Spacer()
                }.onAppear {viewModel2.fetchDishes()}
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .customBack()
    }
}

class DishViewModel: ObservableObject{
    @Published var dishes: [Dish] = []
    @Published var filteredDishes: [Dish] = []
    
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
            filteredDishes = dishes
            
        }catch{
            print("Error fetching dishes: \(error)")
        }
    }

    func filterDishesByPrice(_ dishes: [Dish], by maxPrice: Double) -> [Dish]{
        return dishes.filter{$0.price <= maxPrice}
    }
    
    func filterDishesByName(_ dishes: [Dish], byText serchingText: String = "") -> [Dish]{
        if serchingText == ""{
            return dishes
        }else{
            return dishes.filter{$0.name?.localizedCaseInsensitiveContains(serchingText) ?? false}
        }
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
 
