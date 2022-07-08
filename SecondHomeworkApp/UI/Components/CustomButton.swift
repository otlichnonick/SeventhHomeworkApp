//
//  CustomButton.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width * 0.4, height: 40)
                .background(Color.green)
                .cornerRadius(10)
        }

    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "next", onTap: {})
    }
}
