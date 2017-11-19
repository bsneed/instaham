//
//  Keychain.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

/**
 Fetches a value from the keychain.
 */
+ (NSString * _Nullable)stringForKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName;

/**
 Puts a value in the keychain.  Passing nil for `string` removes the value from the keychain, poor-mans delete.
 */
+ (BOOL)setString:(NSString * _Nullable)string forKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName;

@end
