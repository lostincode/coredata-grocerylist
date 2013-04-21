//
//  ListCDTVC.h
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/20/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ListCDTVC : CoreDataTableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
