//
//  Keychain.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

+ (NSString * _Nullable)stringForKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName;
+ (BOOL)setString:(NSString * _Nullable)string forKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName;

@end
