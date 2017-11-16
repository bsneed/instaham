//
//  AppDelegate.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/16/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

