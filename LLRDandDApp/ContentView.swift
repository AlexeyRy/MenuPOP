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
    
    
    @EnvironmentObject var dataModel: DishDataModel
    @EnvironmentObject var dataProcessor: DataProcessor
    @EnvironmentObject var router: Router
    @EnvironmentObject var categotyManager: CategoryManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var currentDish: Dish?
    
    var body: some View {

        let contentViewModel = ContentViewModel(router: router,
                                                categotyManager: categotyManager,
                                                themeManager: themeManager,
                                                maxPrice: $dataProcessor.maxPrice,
                                                currentDish: $currentDish)
        
        
                VStack {
                    TopBar(dataDelegate: router.currentTopBarData,
                           displayableDelegate: TopBarDisplayableDelegate(viewModel: contentViewModel.topBarViewModel))

                    NavigationView{
                        ZStack{
                            
                            NavigationLink(
                                destination: Settings(
                                    dataDelgate: SettingsData(),
                                    displayDelegate: SettingsDisplay(viewModel: contentViewModel.settingsViewModel)
                                ),
                                tag: .settingsScreen,
                                selection: $router.currentScreen,
                                label: {}
                            )
                            
                            NavigationLink(
                                destination: Filter(
                                    dataDelegate: FilterData(),
                                    displayDelegate: FilterDisplay(
                                        viewModel: contentViewModel.filterViewModel
                                    )
                                ).environmentObject(router)
                                    .onChange(of: dataProcessor.maxPrice){ _ in
                                        print("Хуй размером: \(dataProcessor.maxPrice)")
                                        dataProcessor.filterDishesByPrice()
                                    },// Передаём поведение при изменение окна при вызыве обработчика, так как внутри не работает
                                tag: .filtreationScreen,
                                selection: $router.currentScreen,
                                label: {}
                            )
                            
                            NavigationLink(destination: Info(
                                dataDelegatFoSection: ContentForInfoPage(),
                                dataDelegatForCards: DishCardData(DishInfoForSrcreen: currentDish ?? Dish()),
                                displayDelegate: InfoDisplay(viewModel: contentViewModel.informationViewModel)
                                ),
                                           tag: .information,
                                           selection: $router.currentScreen,
                                           label: {}
                            )
                            
                            VStack{
                                
                                SearchField(dataDelegat: SearchFieldData(), displaybleDelegate: SearchFiledDisplayable(viewModel: dataProcessor))
                                    .padding(.top, 20)
                                    .onChange(of: dataProcessor.searchText){_ in
                                        print("Хуй \(dataProcessor.searchText)")
                                        dataProcessor.filterDishesByName(dataProcessor.searchText)
                                    }
                                
                                ScrollView{
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .mainFood{
                                        Section(dataDelegatFoSection: SectionMainStructData(),
                                                dataDelegatForCards: DataMainFoodsOnli(
                                                    content: dataProcessor.filteredDishes),
                                                displayDelegate: SectionDisplay(
                                                    viewModel: contentViewModel.sectionViewModel)
                                        )
                                    }
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .drinks{
                                        Section(dataDelegatFoSection: SectionDkinksStructData(),
                                                dataDelegatForCards: DataDrinksOnli(
                                                    content: dataProcessor.filteredDishes),
                                                displayDelegate: SectionDisplay(
                                                    viewModel: contentViewModel.sectionViewModel)
                                        )
                                    }
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .desserts{
                                        Section(dataDelegatFoSection: SectionDessertStructData(),
                                                dataDelegatForCards: DataDessertsOnli(
                                                    content: dataProcessor.filteredDishes),
                                                displayDelegate: SectionDisplay(
                                                    viewModel: contentViewModel.sectionViewModel)
                                        )
                                    }
                                }.gesture(DragGesture().onChanged { _ in
                                    UIApplication.shared.endEditing(true) // Закрытие клавиатуры при прокрутке
                                })
                                
                            }
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            .customBack()
                    }
                    Spacer()
                }.onAppear {
                    dataModel.fetchDishes(context: viewContext)
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
    
    init(router: Router,
         categotyManager: CategoryManager,
         themeManager: ThemeManager,
         maxPrice: Binding<Double>,
         currentDish: Binding<Dish?>) {

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
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.filter { $0.isKeyWindow }.first?.endEditing(force)
    }
}


// Не верен как лучше сделать совздавать отдельный класс ViewModel или лучше подсосать класс из контент Viwe. Оставлю пока под вопросом дальше разберусь

 
