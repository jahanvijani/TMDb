//
//  String+Extensions.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

extension String {
    
    func localized(in Bundle:Bundle = Bundle.main) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle, value: "", comment: "")
    }
}
