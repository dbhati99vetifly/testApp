//
//  ViewController.swift
//  testApp
//
//  Created by Deepak on 16/10/20.
//

import UIKit
class ViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet var feedTableView: UITableView!
    var feedArrayData : getData?
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getPostData()
    }
    
    //MARK:- api Calling
    
    func getPostData() {
        getData.getFeeds  {
            (result) in
            switch result {
            case .Success(let feedArray):
                print(feedArray)
                
                self.feedArrayData = feedArray
                
                if self.feedArrayData?.posts?.count ?? 0 > 0 {
                    self.feedTableView.reloadData()
                }
            case .CustomError(let str):
                print(str)
                //self.showError(msg: str)
                //self.hideLoader()
                
            }
        }
    }
    
    
    //MARK:- Functions
    func setUpTableView(){
        let nib = UINib(nibName: "testTVC", bundle: nil)
        feedTableView.register(nib, forCellReuseIdentifier: "testTVC")
    }
    
}

