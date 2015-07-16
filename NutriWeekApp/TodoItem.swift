//
//  ToDoItem.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 12/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    ///Verify if the date to notification is overdue. It is not to happen, because a line in Notifications when it is created.
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending)
    }
}