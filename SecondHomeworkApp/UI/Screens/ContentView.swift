//
//  ContentView.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import SwiftUI
import SwiftUINavigator

struct ContentView: View, IItemView {
    var listener: INavigationContainer?
    
    @StateObject var viewModel: ViewModel = .init()
    var list: [DataModel] {
        viewModel.selectedSegment == 0 ? viewModel.allNewsList : viewModel.topNewsList
    }
    
    var body: some View {
        VStack {
            Text("Для просмотра новостей выберите нужный раздел")
                .font(.title2)
                .foregroundColor(.indigo)
                .padding()
            
            Picker("", selection: $viewModel.selectedSegment) {
                Text("Все")
                    .tag(0)
                Text("Главное")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.selectedSegment) { _ in
                viewModel.getNews()
            }
            
            ZStack {
                VStack {
                    ContentList(list: list,
                                selectedNews: $viewModel.selectedNews) { selectedNews in
                        viewModel.selectedNews = selectedNews
                    } onBottomList: {
                        viewModel.getNews()
                    }
                    
                    Spacer()
                }
                
                if viewModel.allNewsLoadState == .loading || viewModel.topNewsLoadState == .loading {
                    CustomProgressView()
                }
            }
        }
        .onAppear {
            viewModel.getNews()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
