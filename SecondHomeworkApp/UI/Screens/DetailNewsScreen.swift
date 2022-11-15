//
//  DetailNewsScreen.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailNewsScreen: View {
    let news: DataModel
    let onNextTap: () -> Void
    let onPreviousTap: () -> Void
    
    private var url: URL? {
        URL(string: news.image_url ?? "")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WebImage(url: url)
                    .cancelOnDisappear(false)
                    .resizable()
                    .placeholder {
                        Image(systemName: "photo.fill")
                            .renderingMode(.template)
                    }
                    .indicator(.activity)
                    .aspectRatio(contentMode: .fill)
                
                HStack {
                    Text(news.title ?? "")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                HStack {
                    Text(news.description ?? "")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                HStack {
                    CustomButton(title: "к предыдущей", onTap: onPreviousTap)
                                        
                    Spacer()
                    
                    CustomButton(title: "к следующей", onTap: onNextTap)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct DetailNewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailNewsScreen(news: DataModel(), onNextTap: {}, onPreviousTap: {})
    }
}
