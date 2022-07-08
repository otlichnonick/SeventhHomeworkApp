//
//  PickerCell.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import SwiftUI

struct PickerCell: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.callout)
            .foregroundColor(.black)
            .frame(width: UIScreen.main.bounds.width * 0.48, height: 30)
            .background(Color.white)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray, lineWidth: 1)
            }
    }
}

struct PickerCell_Previews: PreviewProvider {
    static var previews: some View {
        PickerCell(title: "Some news")
    }
}
