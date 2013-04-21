//
//  ListCDTVC.m
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/20/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "ListCDTVC.h"
#import "List+Create.h"

@implementation ListCDTVC

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO selector:nil]];
        request.predicate = nil;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - view stuff

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Grocery Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}

#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"List"];
    
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = list.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items", [list.items count]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - UIBarButtonItem

- (IBAction)addListItem:(UIBarButtonItem *)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What is the name of the list?"
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
    if([inputText length] >= 3) {
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
        UITextField *listName = [alertView textFieldAtIndex:0];
        [self.managedObjectContext performBlock:^{
            [List listWithName:listName.text inManagedObjectContext:self.managedObjectContext];
        }];
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"setList:"]) {
            List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setList:)]) {
                [segue.destinationViewController performSelector:@selector(setList:) withObject:list];
            }
        }
    }
}


@end
