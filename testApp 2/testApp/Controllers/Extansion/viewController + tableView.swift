//
//  viewController + tableView.swift
//  testApp
//
//  Created by Deepak on 16/10/20.
//
import UIKit
import Kingfisher

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArrayData?.posts?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = feedTableView.dequeueReusableCell(withIdentifier: "testTVC") as? testTVC else{
            return UITableViewCell()
        }
        let profileUrl = URL(string: feedArrayData?.posts?[indexPath.row].profileImageURL ?? "")
        let postImage = URL(string: feedArrayData?.posts?[indexPath.row].imageURL ?? "")
        
        cell.postImage.kf.setImage(with: postImage)
        cell.userName.text = feedArrayData?.posts?[indexPath.row].name ?? ""
        cell.profileImage.kf.setImage(with: profileUrl)
        cell.postTitle.text = feedArrayData?.posts?[indexPath.row].date ?? ""
        
        cell.postDesc.text = feedArrayData?.posts?[indexPath.row].caption ?? ""
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


