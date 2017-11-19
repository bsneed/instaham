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

+ (NSManagedObjectContext * _Nonnull)managedContext;

@end
