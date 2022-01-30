//
//  DemoFetchedResultsViewController.swift
//  DemoArcade
//
//  Created by Jonathan Rasmusson Work Pro on 2020-03-16.
//  Copyright © 2020 Rasmusson Software Consulting. All rights reserved.
//

import UIKit
import CoreData

class DemoFetchedResultsViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Employee>!
    
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.white.cgColor
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .primaryActionTriggered)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let cellId = "insertCellId"
    
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
    
    // 3
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

extension DemoFetchedResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = employee.name
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
            let employee = self.fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.deleteEmployee(employee: employee)
        })
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
}

// 8
extension DemoFetchedResultsViewController: NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates() // a
    }
    
    // 6b Update table via delegate callback here.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade) // b
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









extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
