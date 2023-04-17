//
//  Extensions.swift
//  NetFlixClone
//
//  Created by 김예림 on 2023/04/12.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
