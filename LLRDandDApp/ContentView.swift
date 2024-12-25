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
    @EnvironmentObject var dataSH: DataSH
    @EnvironmentObject var router: Router
    @EnvironmentObject var categotyManager: CategoryManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataProcesing: DataProcessing
    
    @State var currentDish: Dish?
    @State var isLongPress: Bool = false
    @State var showDelete: Bool = false
    
    /*@StateObject var sectionViewModel = SectionViewMod(tapOnInfo: {},
                                                       dataProcessing: DataProcessing(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)),
                                                       isLongTapActive: .constant(false),
                                                       showDeleteOption: .constant(false)
    )*/
    
    var body: some View {

        let contentViewModel = ContentViewModel(router: router,
                                                categotyManager: categotyManager,
                                                themeManager: themeManager,
                                                maxPrice: $dataSH.maxPrice,
                                                currentDish: $currentDish,
                                                dataProcessing: dataProcesing,
                                                showDelete: $showDelete,
                                                isLongPress: $isLongPress)
        
        
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
                                    .onChange(of: dataSH.maxPrice){ _ in
                                        dataSH.filterDishesByPrice()
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
                                
                                SearchField(dataDelegat: SearchFieldData(), displaybleDelegate: SearchFiledDisplayable(viewModel: dataSH))
                                    .padding(.top, 20)
                                    .onChange(of: dataSH.searchText){_ in
                                        
                                        dataSH.filterDishesByName(dataSH.searchText)
                                    }
                                
                                ScrollView{
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .mainFood{
                                        Section(dataDelegatFoSection: SectionMainStructData(),
                                                dataDelegatForCards: DataMainFoodsOnli(
                                                    content: dataSH.filteredDishes),
                                                displayDelegate: SectionDisplay(viewModel: contentViewModel.sectionViewModel)
                                        )
                                    }
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .drinks{
                                        Section(dataDelegatFoSection: SectionDkinksStructData(),
                                                dataDelegatForCards: DataDrinksOnli(
                                                    content: dataSH.filteredDishes),
                                                displayDelegate: SectionDisplay(viewModel: contentViewModel.sectionViewModel)
                                        )
                                    }
                                    
                                    if categotyManager.currentDishesCategory == .all || categotyManager.currentDishesCategory == .desserts{
                                        Section(dataDelegatFoSection: SectionDessertStructData(),
                                                dataDelegatForCards: DataDessertsOnli(
                                                    content: dataSH.filteredDishes),
                                                displayDelegate: SectionDisplay(viewModel: contentViewModel.sectionViewModel)
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
                    /*
                    sectionViewModel.isLongTapActice = $isLongPress
                    sectionViewModel.showDeleteOption = $showDelete
                    sectionViewModel.tapOnInfo = {router.navigate(to: .information)}
                    sectionViewModel.dataProcessing = dataProcesing
                     */
                    
                    dataModel.fetchDishes(context: viewContext)
                     
                }

                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .customBack()
    }
}

class ContentViewModel: ObservableObject{
    
    @ObservedObject var topBarViewModel: TopBarViewModel
    @ObservedObject var settingsViewModel: SettingsViewMod
    @ObservedObject var filterViewModel: FilterViewModel
    @ObservedObject var informationViewModel: InformationViewModel
    @ObservedObject var sectionViewModel: SectionViewMod
    
    init(router: Router,
         categotyManager: CategoryManager,
         themeManager: ThemeManager,
         maxPrice: Binding<Double>,
         currentDish: Binding<Dish?>,
         dataProcessing: DataProcessing,
         showDelete: Binding<Bool>,
         isLongPress: Binding<Bool>
    ) {

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
        
        self.informationViewModel = InformationViewModel(
            backToMain: {router.navigate(to: .homeScreen)}
        )
        
        self.sectionViewModel = SectionViewMod(
            tapOnInfo: {router.navigate(to: .information)},
            dataProcessing: dataProcessing,
            isLongTapActive: isLongPress,
            showDeleteOption: showDelete,
            currentDish: currentDish
        )
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.filter { $0.isKeyWindow }.first?.endEditing(force)
    }
}


// Не верен как лучше сделать совздавать отдельный класс ViewModel или лучше подсосать класс из контент Viwe. Оставлю пока под вопросом дальше разберусь

 
