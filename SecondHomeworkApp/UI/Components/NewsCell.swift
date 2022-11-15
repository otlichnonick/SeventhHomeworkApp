//
//  NewsCell.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import SwiftUI

struct NewsCell: View {
    var cellData: DataModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cellData.title)
                    .font(.title3)
                
                Text(cellData.description ?? "")
                    .font(.footnote)
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: UIColor.systemGray5))
        .cornerRadius(10)
    }
}
