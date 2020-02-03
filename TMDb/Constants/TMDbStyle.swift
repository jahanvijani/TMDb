//
//  TMDbStyle.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation
import UIKit

struct TMDbStyle {
    struct ColorPalette {
        static let primaryColor = UIColor.color(fromHex: 0x222222)
        static let secondaryColor = UIColor.color(fromHex: 0x21d07a)
    }
    
    struct Font {
        static let headerFont = UIFont(name: "HelveticaNeue-Bold", size: 25)
        static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
        static let contentFont = UIFont(name: "HelveticaNeue", size: 20)
    }
}
