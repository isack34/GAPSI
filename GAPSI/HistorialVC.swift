//
//  HistorialVC.swift
//  GAPSI
//
//  Created by Isaac Rosas on 27/04/19.
//  Copyright © 2019 Isaac Rosas. All rights reserved.
//

import UIKit
import CoreData

class HistorialVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    var arrHist =  [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress()
        getHistporial(completion:{(outcome) in
            DispatchQueue.main.async{
                self.arrHist = outcome
                self.table.reloadData()
                self.hideProgress()
            }
        })
    }
  
    func getHistporial(completion: @escaping (_ outcome: [Any]) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Historial")
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sectionSortDescriptor] as [NSSortDescriptor]
        request.returnsObjectsAsFaults = false
        do {
            let fetched = try context.fetch(request) as [AnyObject]
            completion(fetched)
            
        } catch {
            fatalError("Failed to fetch")
        }
    }
}


extension HistorialVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrHist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell_search
        let str  = self.arrHist[indexPath.row] as! Historial
        cell.historial.text = str.textbusqueda
        return cell
    }
    
    
    
    
}
