//
//  CoreData.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreData: NSObject

/**
 Reduces the need to go type-cast AppDelegate all over the place to get the context.
 Also makes sure i get the same context every time.  I think that's ok, but i'm not positive.
 */
+ (NSManagedObjectContext * _Nonnull)managedContext;

@end
