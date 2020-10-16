//
//  ApiCall+Helper.swift
//
//  Created by Deepak on 29/07/20.

//  Copyright © 2020 Deepak. All rights reserved.
//

import Foundation
import UIKit
import Network
extension APICall {
    
    //MARK:- Request for Application/Json
    
    //    class public func webRequest <T :Decodable>(
    //        apiType: HttpRequestType = .GET,
    //        endPoint: SubUrl,
    //        strID: String = "",
    //        param: Data?,
    //        forceDecoding: Bool = true,
    //        decodableObj: T.Type,
    //        complection: @escaping((ResultAPI<T?>)->())
    //    ){
    
    class public func checkForInternet(_ completion : @escaping((Bool)->())){
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "InternetConnectionMonitor")
            monitor.pathUpdateHandler = { pathUpdateHandler in
                if pathUpdateHandler.status == .satisfied {
                    completion(true)
                    print("Internet connection is on.")
                } else {
                    completion(false)
                    print("There's no internet connection.")
                }
            }
            
            monitor.start(queue: queue)
        } else {
            // Fallback on earlier versions
        }
    }
    
    class public func webRequest (
        apiType: HttpRequestType = .GET,
        url : String,
        param: [String : Any]?,
        forceDecoding: Bool = true,
        //        decodableObj: T.Type,
        complection: @escaping((ResultsAPI)->())
    ){
        
        
        var UrlRequest = URLRequest(url: URL(string: url)!)//finalURL)!)
        UrlRequest.httpMethod = apiType.rawValue
        
        print(url)
        
        if let parameter = param {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted) {
                UrlRequest.httpBody = jsonData
            }
            
        }
        
        header.forEach({
            UrlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            print("key \($0.key), value \($0.value)")
        })
        
        URLSession.shared.dataTask(with: UrlRequest) {(data, httpUrlResponse, error) in
            DispatchQueue.main.async {
                if(data != nil && data?.count != 0)
                {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let result = json as? [String : Any] {
                            print(result)
                            complection(.Success(result))
                        }
                    }
                    catch let decodingError {
                        complection(.CustomError(decodingError.localizedDescription))
                    }
                }else {
                    complection(.CustomError(error?.localizedDescription ?? ""))
                }
            }
        }.resume()
        //                }
        //                else {
        //                    complection(.CustomError("No Interenet Connections"))
        //                }
        //            }
        //   }
        
        
        
    }
    
    
    // MARK:- Request for MultiPart FormData
    
    class public func webRequestMultipart <RS :Decodable, RQ : Codable>(
        apiType: HttpRequestType = .GET,
        url: String,
        strID: String = "",
        param: Data?,
        imageData: Data?,
        imageFileName : String,
        decodableRequestObj : RQ.Type,
        forceDecoding: Bool = true,
        decodableResponseObj: RS.Type,
        complection: @escaping((ResultAPI<RS?>)->())
    ){
        
        //        // Check Network
        //        guard isNetworkAvailable else {
        //            complection(.CustomError(strNoNetwork_Err))
        //            return
        //        }
        
        // Get Final URL
        var finalURL = url// + endPoint.rawValue
        
        //        if !strID.isEmpty {
        //            finalURL = APICall.MainBaseURL + endPoint.rawValue + strID + "/"
        //        }
        //
        var UrlRequest = URLRequest(url: URL(string: finalURL)!, timeoutInterval: Double.infinity)
        UrlRequest.httpMethod = apiType.rawValue
        
        headerForMultipart.forEach({
            UrlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            print("key \($0.key), value \($0.value)")
        })
        
        var body = ""
        
        do {
            let response = try JSONDecoder().decode(decodableRequestObj.self, from: param!)
            for case let (label?, value) in Mirror(reflecting: response)
                .children.map({ ($0.label, $0.value) }) {
                print("label: \(label), value: \(value)")
                
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(label)\""
                let paramValue = value as! String
                body += "\r\n\r\n\(paramValue)\r\n"
            }
        }
        catch let decodingError {
            complection(.CustomError(decodingError.localizedDescription))
        }
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(imageFileName)\""
        var fileData = Data()
        fileData.append(imageData!.base64EncodedString() .data(using: .utf8)!)//try! NSData(contentsOfFile:paramSrc, options:[]) as Data
        let fileContent = String(data: fileData, encoding: .utf8)!
        body += "; filename=\"\(imageData!.base64EncodedString())\"\r\n"
            + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
        
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        UrlRequest.httpBody = postData
        
        URLSession.shared.dataTask(with: UrlRequest) {(data, httpUrlResponse, error) in
            if(data != nil && data?.count != 0)
            {
                do {
                    print(String(data: data!, encoding: .utf8)!)
                    let response = try JSONDecoder().decode(decodableResponseObj.self, from: data!)
                    complection(.Success(response, data ?? Data()))
                }
                catch let decodingError {
                    complection(.CustomError(decodingError.localizedDescription))
                }
            }else {
                complection(.CustomError(error?.localizedDescription ?? ""))
            }
        }.resume()
    }
    
}

