//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Olivia Bishop on 12/6/18.
//  Copyright © 2018 Olivia Bishop. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?

}
