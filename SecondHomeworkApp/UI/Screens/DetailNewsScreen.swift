//
//  DetailNewsScreen.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import SwiftUI
import SwiftUINavigator

struct DetailNewsScreen: View, IItemView {
    var listener: INavigationContainer?
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct DetailNewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailNewsScreen()
    }
}
