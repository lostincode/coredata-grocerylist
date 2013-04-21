//
//  List+Create.h
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/20/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "List.h"

@interface List (Create)

+ (List *)listWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
