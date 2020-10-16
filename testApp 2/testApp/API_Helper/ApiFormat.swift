//
//  ApiFormat.swift
//  Calendar
//
//  Created by Deepak on 09/10/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

//import Alamofire
import Foundation
import SystemConfiguration
import Network

public enum ResultAPI<T> {
    case Success(T, Data)
    case CustomError(String)
}
//public enum Results<T> {
//    case Success(T)
//    case CustomError(String)
//}



class ApiFormat{
    
//    private var headers: HTTPHeaders
//    static let sessionManager: SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 60
//        configuration.timeoutIntervalForResource = 60
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        return sessionManager
//    }()
//
//    //MARK: Initialisation
//    init(){
//
//        headers = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZDk4MzMxYWY5NTIzYjAwMTJkMGE1YWYiLCJlbWFpbCI6ImRlZXBha2JoYXRpOTlAZ21haWwuY29tIiwicGVybWlzc2lvbkxldmVsIjoyMDQ5LCJwcm92aWRlciI6ImVtYWlsIiwibmFtZSI6IkRlZXBhayBCaGF0aSIsInJlZnJlc2hLZXkiOiIrNHNpM2lwRHZJTnY0aC9VYUFFSkxRPT0iLCJpYXQiOjE1NzAyNTU4MDZ9.E-bYdt7EeSInUD_c8gqFebdigrBuzsY0ZsBCa7pV3fA",
//                   "Accept": "*/*",
//                   "Cache-Control": "no-cache",
//                  // "Host": "http://8c5389eb.ngrok.io",
//                   "Accept-Encoding": "gzip, deflate",
//                   "Connection": "keep-alive",
//                   "cache-control": "no-cache"]
//
//    }
    
    class var isConnectedToInternet:Bool {
        return true // NetworkReachabilityManager()?.isReachable ?? false
    }
    
    //MARK: Methods
    //MARK: Methods
    func post(_ url: String, _ params: [String: Any], _ completionHandler: @escaping(_ result: [String: Any]?, _ error: NSError?) -> Void){
        
        APICall.webRequest(apiType: .POST, url: url, param: params, complection: {
            (result) in
            switch result {
            case .Success(let res):
                completionHandler(res, nil)
            case.CustomError(let err):
                completionHandler(nil, err as? NSError)
            }
        })
        

    }
    
    func get(_ url: String, _ completionHandler: @escaping(_ result: [String: Any]?, _ error: NSError?) -> Void){
        
        
        APICall.webRequest(apiType: .GET, url: url, param: nil, complection: {
            (result) in
            switch result {
            case .Success(let res):
                completionHandler(res, nil)
            case.CustomError(let err):
                completionHandler(nil, err as? NSError)
            }
        })
        

    }
  
    // MARK:- Helper Enums
    public enum HttpRequestType: String {
        case GET     = "GET"
        case POST    = "POST"
        case PUT     = "PUT"
        case PATCH   = "PATCH"
        case DELETE  = "DELETE"
    }
    
    public enum EncodingType: String {
        case UrlEncoding     = "urlEncoding"
        case JsonEncoding    = "jsonEncoding"
    }
    
 
    // MARK:-  APICall Request's  --Codable--
    class public func webRequest<T: Codable>(
        apiType: HttpRequestType = .GET,
        Url: String,
        strID: String = "",
        parameters: [String: Any]? = nil,
        encodingType: EncodingType = .UrlEncoding,
        forceDecoding: Bool = true,
        decodableObj: T.Type,
        complection: @escaping((ResultAPI<T?>)->())) {
        
//        // Check Network
//        guard isNetworkAvailable else {
//            complection(.CustomError(strNoNetwork_Err))
//            return
//        }
        
        // Get Final URL
        var finalURL = Url//MainBaseURL + endPoint.rawValue
        if !strID.isEmpty {
            finalURL = Url + strID + "/"//MainBaseURL + endPoint.rawValue + strID + "/"
        }
        
        // Print API Url, Parameters
        debugPrint("-------API Call 🧨-------")
        debugPrint("URL:- ", finalURL)
       // debugPrint("Header:- ", ApiFormat().headers)
        debugPrint("Parameter:- ", parameters ?? [:])
        
        var UrlRequest = URLRequest(url: URL(string: finalURL)!)
        UrlRequest.httpMethod = apiType.rawValue
        
        if let parameter = parameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted) {
                UrlRequest.httpBody = jsonData
            }
            
        }
        
        
        
        
        APICall.header.forEach({
            UrlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            print("key \($0.key), value \($0.value)")
        })
        
        URLSession.shared.dataTask(with: UrlRequest) {(data, httpUrlResponse, error) in
            
            
            DispatchQueue.main.async {
                if(data != nil && data?.count != 0)
                {
                    do {
                        let response = try JSONDecoder().decode(decodableObj.self, from: data!)
                        complection(.Success(response, data ?? Data()))
                    }
                    catch let decodingError {
                        complection(.CustomError(decodingError.localizedDescription))
                    }
                }else {
                    complection(.CustomError(error?.localizedDescription ?? ""))
                }
            }
        }.resume()
        
    }
    
    
    func patch(_ url: String, _ params: [String: Any], _ completionHandler: @escaping(_ result: [String: Any]?, _ error: NSError?) -> Void){
        
        APICall.webRequest(apiType: .PATCH, url: url, param: params, complection: {
            (result) in
            switch result {
            case .Success(let res):
                completionHandler(res, nil)
            case.CustomError(let err):
                completionHandler(nil, err as? NSError)
            }
        })
        
    }
    
    func delete(_ url: String, _ params: [String: Any], _ completionHandler: @escaping(_ result: [String: Any]?, _ error: NSError?) -> Void){
        APICall.webRequest(apiType: .DELETE, url: url, param: params, complection: {
            (result) in
            switch result {
            case .Success(let res):
                completionHandler(res, nil)
            case.CustomError(let err):
                completionHandler(nil, err as? NSError)
            }
        })
        
    }
  
}
