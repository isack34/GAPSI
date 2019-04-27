//
//  Services.swift
//  GAPSI
//
//  Created by Isaac Rosas on 27/04/19.
//  Copyright © 2019 Isaac Rosas. All rights reserved.
//

import Foundation
import UIKit

protocol DelegatesServices: class {
    func extractReturnOk()
    func extractReturnOk(resp: NSArray)
    func extractReturnError(resp: String)
}

class Services:UIViewController {
    weak var delegate: DelegatesServices?
        var strUrl = "https://www.liverpool.com.mx/tienda?s=<producto>&d3106047a194921c01969dfdec083925=json"
        
        func service_search(searchText:String) {
            DispatchQueue.global(qos: .background).async {
            
                self.strUrl = self.strUrl.replacingOccurrences(of: "<producto>", with: searchText)
                
                // request
                let url = URL(string: self.strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                request.timeoutInterval = 60.0
                
                // URL session
                let session = URLSession.shared
                session.dataTask(with: request) {data, response, err in
                    
                    guard let unwrappedData = data else {
                        DispatchQueue.main.async{
                            
                            self.delegate?.extractReturnError(resp: "No se ha obtenido la información.")
                        }
                        return
                        
                    }
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as! [String:AnyObject]
                        print("signIn_JSON ", JSON)
                        
                        let contS = JSON["contents"]! as! [[String:Any]]
                        let mainCont = contS[0] as NSDictionary
                        let mainContT = mainCont["mainContent"] as! NSArray
                        let dicCont = mainContT[Int(mainContT.count-1)] as! NSDictionary
                        let mainProd = dicCont["contents"] as! NSArray
                        let mainRecords = mainProd[0] as! NSDictionary
                        let records = mainRecords["records"] as! NSArray
                        
                        if (records.count > 0){
                            print("success!")
                            DispatchQueue.main.async{
                                self.delegate?.extractReturnOk(resp: records)
                            }
                            
                        } else {
                            DispatchQueue.main.async{
                                self.delegate?.extractReturnError(resp: "No se ha obtenido la información necesaria")
                            }
                        }
                    } catch {
                        print("json error: \(error)")
                        DispatchQueue.main.async {
                            self.delegate?.extractReturnError(resp: error.localizedDescription)
                        }
                    }
                    }.resume()
            }
    }
}

