//
//  AlamofireManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation
import Alamofire

struct AlamofireManager {
    
    static let sharedInstance = AlamofireManager()


    func request(request: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        AF.request(request).responseJSON { response in

            if let data = response.data {
                success(data)
            } else {
                failure(nil)
            }
        }
    }
}
