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
    
    var body: some View {
        VStack {
            Text("Для просмотра новостей выберите нужный город")
                .font(.title2)
                .foregroundColor(.indigo)
                .padding()
            
            Picker("", selection: $viewModel.selectedSegment) {
                Text("Лондон")
                    .tag(0)
                Text("Токио")
                    .tag(1)
                Text("Берлин")
                    .tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
//            ContentList()
            
            Spacer()
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
