//
//  Keychain.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "Keychain.h"
#import <Security/Security.h>



@implementation Keychain

+ (NSString * _Nullable)stringForKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName {
    OSStatus status = noErr;
    NSString *result = nil;
    
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, kSecReturnData,
                           kSecClassGenericPassword, kSecClass,
                           key, kSecAttrAccount,
                           serviceName, kSecAttrService,
                           nil];
    
    CFDataRef resultData = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&resultData);
    
    if (status != noErr) {
        NSLog(@"Reading the keychain failed (code %d)", (int)status);
        return nil;
    }
    
    result = [[NSString alloc] initWithData:(__bridge id)resultData encoding:NSUTF8StringEncoding];
    if (resultData) {
        CFRelease(resultData);
    }
    
    return result;
}

+ (BOOL)setString:(NSString * _Nullable)string forKey:(NSString * _Nonnull)key serviceName:(NSString * _Nonnull)serviceName {
    if (!string) {
        // ah, nil, the poor-mans delete.
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, kSecClass, key, kSecAttrAccount, serviceName, kSecAttrService, nil];
        return (SecItemDelete((__bridge CFDictionaryRef)spec) == noErr);
    } else {
        // ok, they actually gave us a string, get it into the keychain.
        NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, kSecClass, key, kSecAttrAccount, serviceName, kSecAttrService, nil];
        
        if ([Keychain stringForKey:key serviceName:serviceName]) {
            // it exists already, so just update it.
            NSDictionary *update = [NSDictionary dictionaryWithObject:stringData forKey:(__bridge id)kSecValueData];
            OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)spec, (__bridge CFDictionaryRef)update);
            if (status != noErr) {
                NSLog(@"Reading the keychain failed (code %d)", (int)status);
            }
            return (status == noErr);
        } else {
            // it doesn't exist, so add it.
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
            [data setObject:stringData forKey:(__bridge id)kSecValueData];
            OSStatus status = SecItemAdd((__bridge CFDictionaryRef)data, NULL);
            if (status != noErr) {
                NSLog(@"Reading the keychain failed (code %d)", (int)status);
            }
            return (status == noErr);
        }
    }
}

@end
