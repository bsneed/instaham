//
//  Conversion.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Conversion)

/**
 These extensions make fishing things out of dictionaries a little safer, and reduces
 the number of 'if' statements necessar.
 */

- (NSNumber * _Nullable)numberValue;
- (NSString * _Nullable)stringValue;

@end
