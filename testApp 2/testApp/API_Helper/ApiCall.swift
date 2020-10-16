//
//  ApiCall.swift

//
//  Created by Deepak on 29/07/20.
//  Copyright © 2020 Deepak. All rights reserved.
//

import Foundation
import SystemConfiguration
import Network

public enum ResultsAPI {
    case Success([String:Any])
    case CustomError(String)
}

public enum Results<T> {
    case Success(T)
    case CustomError(String)
}

// MARK:- Helper Enums
public enum HttpRequestType: String {
    case GET     = "GET"
    case POST    = "POST"
    case PUT     = "PUT"
    case PATCH   = "PATCH"
    case DELETE  = "DELETE"
}

//https://gorcis.com/social-api/posts/fetch-trending-posts.php
final class APICall {

    public enum EncodingType: String {
        case UrlEncoding     = "urlEncoding"
        case JsonEncoding    = "jsonEncoding"
    }
    
    public enum SubUrl: String{
        
        case fetchTrendingPosts = "fetch-trending-posts.php"

//        var Path : String {
//
//            var url = ""
//            switch self {
//            case .fetchTrendingPosts :
//                 url = "fetch-trending-posts.php"
//            }
//            return url
//        }
    }
    
    
    
    struct ErrorMessageModel: Codable {
        let detail: String?
        let message: String?
    }
    
    // MARK:- Private/Internal Variables
    static internal let strNoData_Err           = "Response data is null."
    static internal let strNoNetwork_Err        = "Network not available. Please try again...!"
   // static private let reachabilityManager      = NetworkReachabilityManager()
    

    
    static internal var header: [String : String]  {
        var headers = [String: String]()
        
//        if let loginModel = KeychainManager.shared.getDriverLoginAndProfileData(), let accessToken = loginModel.accessToken {
            headers["API-KEY"] = "test_mhsn"
//            }
        
//        if let authToken = UserData.AccessToken {
//            headers["Authorization"] = "Bearer " + authToken
//        }
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    
    static let boundary = "Boundary-\(UUID().uuidString)"//"---------------------------------\(UUID().uuidString)"
    
    static internal var headerForMultipart: [String : String]  {
        var headers = [String: String]()
        //        if let authToken = UserData.returnValue(.token) as? String {
        //            let strToken = "Token" //+ " " + authToken
        //            headers["Authorization"] = strToken
        //            headers["Accept"] = "application/json"
        headers["API-KEY"] = "test_mhsn"
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        //        }
        return headers
    }
    
    
    
    // MARK:- Public Variables
    static var isStaging            = false
    static var isNetworkAvailable   = false
    static var MainBaseURL: String  = {
        return "https://gorcis.com/social-api/posts/"
    }()
    
    
    
    // MARK:- Public Network availibility
    class public func networkAvailibity() {
//        reachabilityManager?.listener = { (status) in
//            switch status {
//            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
//                isNetworkAvailable = true
//                debugPrint("🗼⚡️⚡️⚡️Internet Available⚡️⚡️⚡️🗼")
//
//            case .unknown, .notReachable:
//                isNetworkAvailable = false
//                debugPrint("🗼⚡️⚡️⚡️Internet Not Available⚡️⚡️⚡️🗼")
//            }
//        }
//        reachabilityManager?.startListening()
    }
} //class

