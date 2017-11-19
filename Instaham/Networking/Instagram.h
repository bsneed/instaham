//
//  Instagram.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/16/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ServiceCompletion)(NSError * _Nullable error);

@interface Instagram : NSObject

@property (nonatomic, readonly) BOOL hasToken;
@property NSString * _Nullable token;

+ (NSURL * _Nullable)authURL;
+ (void)setToken:(NSString * _Nullable)token;

- (void)recentForUserWithCompletion:(ServiceCompletion _Nullable)completion;

@end
