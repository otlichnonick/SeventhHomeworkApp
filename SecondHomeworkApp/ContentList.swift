//
//  ContentList.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import SwiftUI

struct ContentList: View {
    var list: NewsModel
    var body: some View {
        ScrollView {
        LazyVStack {
            
        }
        }
    }
}

struct ContentList_Previews: PreviewProvider {
    static var previews: some View {
        ContentList(list: NewsModel(meta: MetaModel(found: 1, page: 1), data: [DataModel(uuid: "", title: "", description: "", image_url: "")]))
    }
}
