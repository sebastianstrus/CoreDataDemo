//
//  Employee+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Sebastian Strus on 2022-01-28.
//

import Foundation
import CoreData

extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?

}

extension Employee : Identifiable {

}
