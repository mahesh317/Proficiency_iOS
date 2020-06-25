//
//  ServiceManager.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public enum ServiceResult<T> {
    case failure(Error)
    case success(T)
}



fileprivate enum ServiceParamType{
    case facts(String)
    
    var path:String{
        switch self {
        case .facts(_): return "facts.json"
        }
    }
    
    var url:URL?{
        switch self {
        case .facts(let base): return URL(string: base + self.path)
        }
    }
    
}

class ServiceManager {
    
    private let baseUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/"
    
    static let sharedInstance = ServiceManager()
    
    private init() {
    }
    
    func getFacts(callback: @escaping (ServiceResult<Facts>) -> Void){
        guard let url = ServiceParamType.facts(baseUrl).url else {
            return
        }
        
        AF.request(url, method: .get ,encoding: JSONEncoding.default).responseData(completionHandler: { (response) in
            if let error = response.error {
                callback(.failure(error))
                return
            }
            guard let responseData = response.data else{
                return
            }
                        
            let responseStrInISOLatin = String(data: responseData, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let facts = try decoder.decode(Facts.self, from: modifiedDataInUTF8Format)
                callback(.success(facts))
            } catch (let exception){
                print(exception.localizedDescription)
                callback(.failure(exception))
            }
            
        })
        
        
    }
    
}
