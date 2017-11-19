//
//  Conversion.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "Conversion.h"

@implementation NSObject(Conversion)

- (NSNumber * _Nullable)numberValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
    return nil;
}

- (NSString * _Nullable)stringValue {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    return nil;
}
@end
