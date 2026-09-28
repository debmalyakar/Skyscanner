//
//  JsonLoader.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 27/09/26.
//

import Foundation

class JsonLoader {
  static func loadJson(from file : String) -> Data {
        guard let url =  Bundle(for: AnchorClass.self).url(forResource: file, withExtension: "json") else {
            return Data()
        }
        
        return try! Data(contentsOf: url)
    }
}

class AnchorClass {}
