//
//  CoreData.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "CoreData.h"
#import "AppDelegate.h"

@import CoreData;

static NSManagedObjectContext * __mainContext = nil;

@implementation CoreData

+ (NSManagedObjectContext * _Nonnull)managedContext {
    //if (__mainContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        __mainContext = appDelegate.persistentContainer.viewContext;
        //[__mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    //}
    return __mainContext;
}

@end
