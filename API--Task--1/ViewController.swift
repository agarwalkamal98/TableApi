//
//  ViewController.swift
//  API--Task--1
//
//  Created by kamal agarwal on 11/04/21.
//


import Kingfisher
import UIKit
import WebKit

class ViewController: UIViewController{
  
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var tableV: UITableView!
    var responseArr = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apicall()
    }
    
    func apicall(){
        
        let url = URL(string: "https://random-data-api.com/api/users/random_user?size=3")
        let urlReq = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: urlReq) { (data, resp, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            if let dataResp = data{
                do{
                    let jsonResp = try JSONSerialization.jsonObject(with: dataResp, options: .mutableContainers) as? [NSDictionary]
                    
                    print(jsonResp)
                    
                    guard let arr = jsonResp else {
                        return
                    }
                    self.responseArr = arr
                    
                    print("hello")
                  
                    DispatchQueue.main.async {
                        self.tableV.reloadData()
                       // var activityview = self.actInd
                        self.actInd.startAnimating()
                        
                        self.actInd.stopAnimating()
                    }
                    
                    
                }
                catch{
                    
                }
            }
            
            
        }.resume()
       
    }
    
    
}


extension  ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
        let firstNme = responseArr[indexPath.row].value(forKey: "first_name") as! String
        let lasTNme = responseArr[indexPath.row].value(forKey: "last_name") as! String
        let emailNme = responseArr[indexPath.row].value(forKey: "email") as! String
        
        let imgArr = responseArr[indexPath.row].value(forKey: "avatar") as! String
        
        cell.firstLbl.text = "\(firstNme)"
        cell.lastLbl.text = "\(lasTNme)"
        cell.emailLbl.text = "\(emailNme)"
        
        
        
        if let imgurl = URL(string: imgArr){
            cell.img.kf.setImage(with: imgurl)
        }else{
            cell.img.backgroundColor = UIColor.red
        }
        //
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    
}



class customTVC:UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var lastLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
}

