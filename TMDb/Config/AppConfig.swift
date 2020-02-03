//
//  AppConfig.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct AppConfig {
    
    static var baseUrl: URL {
        guard var urlString = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            fatalError("Config file is not setup")
        }
        
        urlString = urlString.replacingOccurrences(of: "\\", with: "")
        
        guard let url = URL(string: urlString) else {
          fatalError("Invalid url")
        }
        return url
    }
    
    static var imageBaseUrl: URL {
        guard var urlString = Bundle.main.infoDictionary?["ImageBaseURL"] as? String else {
            fatalError("Config file is not setup")
        }
        
        urlString = urlString.replacingOccurrences(of: "\\", with: "")
        
        guard let url = URL(string: urlString) else {
          fatalError("Invalid url")
        }
        return url
    }
    
    static var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("Config file is not setup")
        }
        return apiKey
    }
}
