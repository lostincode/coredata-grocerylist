//
//  Item+Create.m
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/21/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "Item+Create.h"
#import "List+Create.h"

@implementation Item (Create)

+ (Item *)itemWithName:(NSString *)name forList:(List *)list inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    item.name = name;
    item.done = [NSNumber numberWithBool:NO];
    item.list = [List listWithName:list.name inManagedObjectContext:context];
    item.date = [NSDate date];
    
    return item;
}

@end
