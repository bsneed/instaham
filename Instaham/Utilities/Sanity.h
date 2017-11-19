//
//  Sanity.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#ifndef Sanity_h
#define Sanity_h

/*
 So I don't go insane typing all the weak/strong shit for use in blocks.
 */

#define weakify(var) \
    try {} @finally {} \
    __weak typeof(var) self_weak_##var = var;

#define strongify(var) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    try {} @finally {} \
    __strong typeof(var) var = self_weak_##var; \
    _Pragma("clang diagnostic pop")

#endif /* Sanity_h */
