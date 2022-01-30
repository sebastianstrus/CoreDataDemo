//
//  DemoFetchedResultsViewController.swift
//  CoreDataDemo
//
//  Created by Sebastian Strus on 2022-01-30.
//

import UIKit
import CoreData

class DemoFetchedResultsViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Employee>!
    
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    
    private lazy var textField: UITextField = {
        let textField = UITextField(placeholder: "Employee's name")
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(title: "Add")
        button.addTarget(self, action: #selector(addButtonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        loadSavedData()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    func layout() {
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor.darkGray
        navigationItem.title = "Fetched Results Demo"
        
        
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        textField.setAnchor(top: view.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            paddingTop: 0,
                            paddingLeft: 4,
                            paddingBottom: 0,
                            paddingRight: 4,
                            width: view.bounds.width * 0.8,
                            height: 50)
        
        addButton.setAnchor(top: view.topAnchor,
                            leading: textField.trailingAnchor,
                            bottom: textField.bottomAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 0,
                            paddingLeft: 4,
                            paddingBottom: 0,
                            paddingRight: 4)
        
        tableView.setAnchor(top: textField.bottomAnchor,
                            leading: view.leadingAnchor,
                            
                            bottom: view.bottomAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 8,
                            paddingLeft: 4,
                            paddingBottom: 4,
                            paddingRight: 4)
        
        
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<Employee>(entityName: "Employee")
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: - Actions
    @objc
    func addButtonPressed() {
        guard let name = textField.text else { return }
        CoreDataManager.shared.createEmployee(name: name)
        textField.text = ""
    }
}

// MARK:  - UITableView DataSource
extension DemoFetchedResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = employee.name
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
}

// MARK:  - UITableViewDelegate
extension DemoFetchedResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
            let employee = self.fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.deleteEmployee(employee: employee)
        })
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

// MARK:  - NSFetchedResultsControllerDelegate
extension DemoFetchedResultsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Update table via delegate callback here.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

