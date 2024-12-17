//
//  ContentView.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Dish.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)]) private var dishItems: FetchedResults<Dish>
    @StateObject var viewModel: DishesViewModel
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var categotyManager: CategoryManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var maxPrice: Double = 60
    @State var currentDish: Dish?
    
    var body: some View {

        
        let filterDishCore = FilterForFoodCore(viewModel.dishes, maxPrice)
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
                                                content: filterDishCore),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .drinks{
                                    Section(dataDelegatFoSection: SectionDkinksStructData(),
                                            dataDelegatForCards: DataDrinksOnli(
                                                content: filterDishCore),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .desserts{
                                    Section(dataDelegatFoSection: SectionDessertStructData(),
                                            dataDelegatForCards: DataDessertsOnli(
                                                content: filterDishCore),
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
                }.onAppear {viewModel.updateDishes(with: dishItems)}
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .customBack()
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
 
