//
//  ItemsForListCDTVC.m
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/20/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "ItemsForListCDTVC.h"
#import "Item+Create.h"

@implementation ItemsForListCDTVC

- (void) setList:(List *)list
{
    _list = list;
    self.title = list.name;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if (self.list.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        //request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"done" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"done" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:nil]];
        request.predicate = [NSPredicate predicateWithFormat:@"list = %@", self.list];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.list.managedObjectContext
                                                                              sectionNameKeyPath:@"done"
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
    cell.accessoryType = [item.done boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected item at section %i with row %i", indexPath.section, indexPath.row);
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    item.done = [item.done boolValue] ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
    //[self.list.managedObjectContext save:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [[sectionInfo name] isEqual: @"0"] ? @"Items I Need" : @"Done";

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.list.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - UIBarButtonItem

- (IBAction)addItemToList:(UIBarButtonItem *)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What is the name of the item?"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Add", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}

#pragma mark - UIAlertView

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if([inputText length] >= 2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Add"])
    {
        UITextField *itemName = [alertView textFieldAtIndex:0];
        [self.list.managedObjectContext performBlock:^{
            [Item itemWithName:itemName.text forList:self.list inManagedObjectContext:self.list.managedObjectContext];
        }];
    }
}

@end
