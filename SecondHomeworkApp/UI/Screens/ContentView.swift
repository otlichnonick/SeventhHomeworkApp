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
                        Text("Для просмотра новостей выберите нужный раздел")
                            .font(.title2)
                            .foregroundColor(.indigo)
                            .padding()
                            .background(
                                GeometryReader(content: { geometry in
                                    Color.clear
                                        .preference(key: TitlePreferenceKey.self, value: geometry.size)
                                        .onPreferenceChange(TitlePreferenceKey.self) { value in
                                            self.titleSize = value
                                        }
                                })
                            )
                        
                        Picker("", selection: $viewModel.selectedSegment) {
                            Text(NewsType.all.title)
                                .tag(0)
                            Text(NewsType.top.title)
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: viewModel.selectedSegment) { _ in
                            if viewModel.list.isEmpty {
                            viewModel.getNews()
                            }
                            movePickerItem()
                        }
                        
                        ZStack {
                            VStack {
                                ContentList(list: viewModel.list,
                                            selectedNews: $viewModel.selectedNews) { selectedNews in
                                    viewModel.selectedNews = selectedNews
                                    navIsActive.toggle()
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
                
                if showPickerItem {
                    VStack {
                        Color.clear
                            .frame(width: titleSize.width, height: titleSize.height)
                    
                    HStack {
                        PickerCell(title: NewsType.all.title)
                            .opacity(viewModel.selectedSegment != 0 ? 0 : 1)
                            .offset(x: 0, y: yPosition)
                        
                        PickerCell(title: NewsType.top.title)
                            .opacity(viewModel.selectedSegment == 0 ? 0 : 1)
                            .offset(x: 0, y: yPosition)
                    }
                        
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .cancel())
            }
            .onAppear {
                viewModel.getNews()
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
    
    private func movePickerItem() {
        showPickerItem = true
        withAnimation(Animation.easeIn(duration: 2), {
            yPosition = UIScreen.main.bounds.height * 0.9
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showPickerItem = false
                yPosition = 0
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TitlePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}
