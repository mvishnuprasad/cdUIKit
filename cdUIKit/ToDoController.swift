//
//  ToDoController.swift
//  cdUIKit
//
//  Created by vishnuprasad on 08/06/25.
//

import UIKit
import CoreData
class ToDoController: UITableViewController , UISearchBarDelegate{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
    //@IBOutlet weak var searchBar : UISearchBar!
        // var itemArray = [Item]()
    var itemArray = [ToDoItem]()
    var selCat : Categories? {
        didSet {
            load ()
        }
    }

//    let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Itmes.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // searchBar.delegate = self
//        if let items = defaults.array(forKey: "itemArray") as? [Item]{
//            itemArray = items
//        }
       
        // Do any additional setup after loading the view.
    }
    
    
}


extension ToDoController  {
    func save(){
      //  let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        }catch{
            fatalError("Error \(error)")
        }
    }
    func load () {
//        let decoder = PropertyListDecoder()
//        if let data = try? Data(contentsOf: dataFilePath!){
//            do {
//                
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                fatalError("Error \(error)")
//            }
//        }
        let predicate = NSPredicate(format: "parent.name MATCHES %@", (selCat?.name)!)
        request.predicate = predicate
        do {
            itemArray = try context.fetch(request)
        }catch{
            fatalError("Error \(error)")
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell" , for : indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
      //  cell.accessoryType = itemArray[indexPath.row].isCompleted ? .checkmark : .none
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //itemArray[indexPath.row].isCompleted.toggle()
         

        itemArray[indexPath.row].isDone.toggle()
        
        self.save()
        tableView.reloadData()
        //        if ( tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            context.delete(itemArray[indexPath.row])  
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath],with: .automatic)
            self.save()
        }
    }
    @IBAction   func addPressed(_ sender : UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item" , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //self.itemArray.append(Item(title: textField.text ?? "", isCompleted: false))
            //self.defaults.set(self.itemArray, forKey: "itemArray")
            let item = ToDoItem(context: self.context)
            item.title = textField.text ?? ""
            item.isDone = false
            item.parent  = self.selCat
            self.itemArray.append(item)
            self.save()
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
}

extension ToDoController {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let req  : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS %@",  searchBar.text!)
        req.predicate = predicate
        let sort = NSSortDescriptor(key: "title", ascending: true)
        req.sortDescriptors = [sort]
        do {
            itemArray = try context.fetch(req)
        }catch{
            fatalError("Error \(error)")
        }
        tableView.reloadData()
    }
}
