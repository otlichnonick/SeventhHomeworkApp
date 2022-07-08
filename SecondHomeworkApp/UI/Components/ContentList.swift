//
//  ContentList.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import SwiftUI

struct ContentList: View {
    var list: [DataModel]
    @Binding var selectedNews: DataModel?
    let onTap: (DataModel) -> Void
    let onBottomList: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(list, id: \.self.uuid) { newsItem in
                    NewsCell(cellData: newsItem)
                        .onTapGesture {
                            onTap(newsItem)
                        }
                        .onAppear {
                            if newsItem.uuid == list.last?.uuid {
                                onBottomList()
                            }
                        }
                }
            }
        }
    }
}
