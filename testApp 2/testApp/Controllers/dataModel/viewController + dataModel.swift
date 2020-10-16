//
//  viewController + dataModel.swift
//  testApp
//
//  Created by Deepak on 16/10/20.
//

import Foundation

// MARK: - Empty
struct getData: Codable {
    let error: Bool?
    let errorCode: Int?
    let posts: [Post]?
    
   static func getFeeds( _ complection: ((Results<getData?>)->Void)?) {
         
    let url = APICall.MainBaseURL + APICall.SubUrl.fetchTrendingPosts.rawValue

      //  self.showLoader()
//    {
//      "userToken":"08c5128e-436a-480c-8de6-9a411b8ed108",
//      "startIndex":0,
//      "limit":5
//    }
    
    let param = ["userToken": "08c5128e-436a-480c-8de6-9a411b8ed108",
                 "startIndex": 0,
                 "limit": 10,] as [String : Any]
    
    ApiFormat.webRequest(apiType: .POST, Url:url , parameters: param, decodableObj: getData.self) { (result) in
            switch result {
            case .Success(let obj, _):

                complection?(.Success(obj))
                
            case .CustomError(let str):
                complection?(.CustomError(str))
            }
        }
    }
    
}

// MARK: - Post
struct Post: Codable {
    let postToken: String?
    let likeCount, commentCount: Int?
    let username: String?
    let imageURL, placeholderImageURL: String?
    let aspectRatio: Int?
    let caption: String?
    let timestamp: Int?
    let date, name: String?
    let profileImageURL: String?
    let hasLikedPost, isVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case postToken, likeCount, commentCount, username
        case imageURL = "imageUrl"
        case placeholderImageURL = "placeholderImageUrl"
        case aspectRatio, caption, timestamp, date, name
        case profileImageURL = "profileImageUrl"
        case hasLikedPost, isVerified
    }
}
