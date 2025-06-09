//
//  ToDoController.swift
//  cdUIKit
//
//  Created by vishnuprasad on 08/06/25.
//

import UIKit

class ToDoController: UITableViewController {
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Itmes.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let items = defaults.array(forKey: "itemArray") as? [Item]{
//            itemArray = items
//        }
        load ()
        // Do any additional setup after loading the view.
    }
    
    
}


extension ToDoController  {
    func save(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            fatalError("Error \(error)")
        }
    }
    func load () {
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!){
            do {
                
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                fatalError("Error \(error)")
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell" , for : indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isCompleted ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isCompleted.toggle()
        tableView.reloadData()
        self.save()
        //        if ( tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction   func addPressed(_ sender : UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item" , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            self.itemArray.append(Item(title: textField.text ?? "", isCompleted: false))
            //self.defaults.set(self.itemArray, forKey: "itemArray")
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
