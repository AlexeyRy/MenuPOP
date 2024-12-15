//
//  ContentView.swift
//  LLRDandDApp
//
//  Created by Alexey Chermnykh on 7.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var themeManager: ThemeManager
    @State var maxPrice: Double = 60
    @State var currentDish: Dishes = Dishes(dishesCategory: .all,
                                            Title: "",
                                            name: "",
                                            price: 0.00,
                                            ingridients: [""],
                                            peculiarity: "",
                                            isHot: "",
                                            isAlcogolic: "",
                                            withsugar: "")
    
    var body: some View {
        
        let filterDishes = FilterForFood(allFood, maxPrice)
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
            isButtonChoosed: router.dishesCategory,
            maxPrice: $maxPrice,
            chooseCategoryOfDishesAll: {router.changeCategory(choose: .all)},
            chooseCategoryOfDishesMain: {router.changeCategory(choose: .mainFood)},
            chooseCategoryOfDishesDrinks: {router.changeCategory(choose: .drinks)},
            chooseCategoryOfDishesDesserts: {router.changeCategory(choose: .desserts)},
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
                                dataDelegatForCards: DishCardData(DishInfoForSrcreen: currentDish),
                                displayDelegate: InfoDisplay(viewModel: informationViewModel)
                            ),
                                           tag: .information,
                                           selection: $router.currentScreen,
                                           label: {})
                            
                            
                            
                            ScrollView{
                                if router.dishesCategory == .all || router.dishesCategory == .mainFood{
                                    Section(dataDelegatFoSection: SectionMainStructData(),
                                            dataDelegatForCards: DataMainFoodsOnli(
                                                content: filterDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if router.dishesCategory == .all || router.dishesCategory == .drinks{
                                    Section(dataDelegatFoSection: SectionDkinksStructData(),
                                            dataDelegatForCards: DataDrinksOnli(
                                                content: filterDishes),
                                            displayDelegate: SectionDisplay(
                                                viewModel: sectionViewModel)
                                    )
                                }
                                if router.dishesCategory == .all || router.dishesCategory == .desserts{
                                    Section(dataDelegatFoSection: SectionDessertStructData(),
                                            dataDelegatForCards: DataDessertsOnli(
                                                content: filterDishes),
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
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .customBack()
    }
}

#Preview {

    ContentView(currentDish: Dishes(dishesCategory: .all,
                                    Title: "",
                                    name: "",
                                    price: 0.00,
                                    ingridients: [""],
                                    peculiarity: "",
                                    isHot: "",
                                    isAlcogolic: "",
                                    withsugar: ""))
        .environmentObject(Router())
        .environmentObject(ThemeManager())
}
