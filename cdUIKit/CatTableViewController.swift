//
//  CatTableViewController.swift
//  cdUIKit
//
//  Created by qbuser on 09/06/25.
//

import UIKit
import CoreData
import RealmSwift
 
class CatTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let req : NSFetchRequest<Categories> = Categories.fetchRequest()
//    var itemArray = [Categories]()
  
     
    let realm = try! Realm()
    var itemArray : Results<CatData>?
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    func save(itemArray : CatData) {
//        do {
//            try context.save()
//        }catch{
//            print("err")
//        }
        do {
            try realm.write {
                realm.add(itemArray)
            }
        }catch{
            print("err")
        }
    }
    func load(){
//        do {
//            itemArray = try context.fetch(req)
//        }catch{
//            print("err")
//        }
        itemArray = realm.objects(CatData.self)

    }
    func del(itemArray : CatData) {
        do {
        try realm.write({
        realm.delete(itemArray)
            })
        }
        catch {
        //Error
            }
    }

    @IBAction func add (_ sender : UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item" , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //self.itemArray.append(Item(title: textField.text ?? "", isCompleted: false))
            //self.defaults.set(self.itemArray, forKey: "itemArray")
            //let item = Categories(context: self.context)
            let item = CatData( )
            item.name = textField.text ?? ""
           
           // self.itemArray.append(item)
            self.save(itemArray: item)
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell" , for: indexPath)
        cell.textLabel?.text = itemArray?[indexPath.row].name
        return cell
         
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ToDoController
        if let indexPath = tableView.indexPathForSelectedRow {
            dest.selCat = itemArray?[indexPath.row]
        }
    }
}
