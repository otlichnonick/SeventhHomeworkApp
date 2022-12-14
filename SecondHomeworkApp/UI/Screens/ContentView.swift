//
//  ContentView.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = .init()
    @State private var navIsActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showPickerItem: Bool = false
    @State private var yPosition: CGFloat = 0
    @State private var titleSize: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ContentList(list: viewModel.allNewsList,
                                selectedNews: $viewModel.selectedNews) { selectedNews in
                        viewModel.selectedNews = selectedNews
                        navIsActive.toggle()
                    } onBottomList: {
                        viewModel.downloadAllNews()
                    }
                    
                    Spacer()
                }
                .padding()

                if viewModel.allNewsLoadState == .loading {
                    CustomProgressView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .cancel())
            }
            .onAppear {
                viewModel.showAllNews()
            }
            .background {
                viewModel.selectedNews.map { news in
                    NavigationLink(isActive: $navIsActive) {
                        ZStack {
                            DetailNewsScreen(news: news) {
                                tryToShowNextNews()
                            } onPreviousTap: {
                                tryToShowPreviousNews()
                            }
                            
                            if viewModel.detailNewsLoadState == .loading {
                                CustomProgressView()
                            }
                        }
                    } label: {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func tryToShowNextNews() {
        if let uuid = viewModel.nextNewsUuid {
            viewModel.getDetailNews(with: uuid)
        } else {
            showErrorAlert(with: "Не удается загрузить следующую новость")
        }
    }
    
    private func tryToShowPreviousNews() {
        if let uuid = viewModel.previousNewsUuid {
            viewModel.getDetailNews(with: uuid)
        } else {
            showErrorAlert(with: "Не удается загрузить предыдущую новость")
        }
    }
    
    private func showErrorAlert(with text: String) {
        showAlert.toggle()
        errorMessage = text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
