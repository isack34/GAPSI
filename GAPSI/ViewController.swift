//
//  ViewController.swift
//  GAPSI
//
//  Created by Isaac Rosas on 27/04/19.
//  Copyright © 2019 Isaac Rosas. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var table: UITableView!
    var arrDic = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 600
        
    }

    @IBAction func btn_buscar(_ sender: UIButton) {
        let countString = search.text!
        if(countString.count > 0){
            closeKeyboard()
            showProgress()
            let serv = Services.init()
            serv.delegate = self
            serv.service_search(searchText: countString)
            guardarBusqueda(busqueda:countString)
        }else{
            alertGeneric(msg: "Por favor ingresa una busqueda")
        }
    }
    
    func guardarBusqueda(busqueda:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entCategorias = NSEntityDescription.entity(forEntityName: "Historial", in: context)
        var his : Historial?
        his = NSManagedObject(entity: entCategorias!, insertInto: context) as? Historial
        his!.textbusqueda = busqueda
    
        //Save Context
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("historial coredata")
            }
        }
    }
    
    func closeKeyboard(){
        search.resignFirstResponder()
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell_search
        let dic = arrDic[indexPath.row] as! NSDictionary
        let nom = dic["productDisplayName"] as! NSArray
        cell.nombre.text = (nom[0] as! String)
        let pre = dic["productPrice"] as! NSArray
        cell.precio.text = (pre[0] as! String)
        let im = dic["smallImage"] as! NSArray
        let url = URL.init(string: (im[0] as! String))
        cell.img.sd_setImage(with: url , placeholderImage: nil)
        return cell
    }
}

extension ViewController:DelegatesServices{
    func extractReturnOk(resp: NSArray) {
        arrDic = resp
        table.reloadData()
        hideProgress()
    }
    func extractReturnOk() {
        hideProgress()
    }
    func extractReturnError(resp: String) {
        hideProgress()
        alertGeneric(msg:resp)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarIsEmpty() -> Bool {
        return search.text?.isEmpty ?? true
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        self.search.resignFirstResponder()
    }
    
}

extension UIViewController {
    
    func showProgress(){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Cargando"
    }
    func hideProgress(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func alertGeneric(msg:String){
        let alertController = UIAlertController(title: "Atención", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
