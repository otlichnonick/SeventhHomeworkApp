//
//  Array + Ext.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
