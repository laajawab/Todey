//
//  ViewController.swift
//  Todey
//
//  Created by Avilash on 04/10/18.
//  Copyright © 2018 Avilash. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    var todoItems : Results<Item>?
    let realm = try! Realm ()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCatagory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCatagory?.name
        
        guard let hexColour = selectedCatagory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: hexColour)

        }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK:- NavBar SetupMethods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller doesn't exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        searchBar.barTintColor = navBarColour
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
    }
    

    
    //MARK - TableView DataSource Method.

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let cellColour = UIColor(hexString: selectedCatagory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = cellColour
                cell.textLabel?.textColor = ContrastColorOf(cellColour, returnFlat: true)
            }
            
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row]{
            do  {
                try realm.write {
                    
                    item.done = !item.done
                }
            } catch {
                print("Error Saing Done Status \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Local Variable.💪
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click the add item button on our UIAlert.
            
            if let currentCategory = self.selectedCatagory {
                do {
                try self.realm.write {
                
                let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                
                }catch {
                    print("Error Saving New Item")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            // Extending the scope of 'textField' using local variable tobe used in UIAlertAction.
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Modal Manupulation Methods.
    
    
    func loadItems () {
        
        todoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    //MARK:- Delete Items.
    override func updateModel(at indexPath: IndexPath) {
        if let itemsForDeletion = self.todoItems?[indexPath.row] {
            do {
            try self.realm.write {
                self.realm.delete(itemsForDeletion)
            }
            }
            catch {
                print("Deletion Error todoItems \(error)")
        }
        }
        
    }
    
}
    
    //MARK: - Search Bar Methods.

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
    
   
