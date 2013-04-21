//
//  List+Create.m
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/20/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "List+Create.h"

@implementation List (Create)

+ (List *)listWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    List *list = nil;
    
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            
        } else if (![matches count]) {
            list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
            list.name = name;
            list.date = [NSDate date];
        } else {
            list = [matches lastObject];
        }
    }
    
    return list;
}

@end
