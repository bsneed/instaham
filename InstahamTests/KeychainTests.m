//
//  KeychainTests.m
//  InstahamTests
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Keychain.h"

@interface KeychainTests : XCTestCase

@end

@implementation KeychainTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testKeychain {
    NSString *key = @"muh_key";
    NSString *service = @"myService";
    NSString *value = @"ham sammich";
    
    BOOL bResult = FALSE;
    NSString *sResult = nil;
    
    // it shouldn't be there.
    sResult = [Keychain stringForKey:key serviceName:service];
    XCTAssertNil(sResult);
    
    // set it, should return true.
    bResult = [Keychain setString:value forKey:@"muh_key" serviceName:@"myService"];
    XCTAssertTrue(bResult);
    
    // it should be there now.
    sResult = [Keychain stringForKey:key serviceName:service];
    XCTAssertNotNil(sResult);
    
    // now remove it.
    bResult = [Keychain setString:nil forKey:key serviceName:service];
    XCTAssertTrue(bResult);

    // it should've been removed now.
    sResult = [Keychain stringForKey:key serviceName:service];
    XCTAssertNil(sResult);
}


@end
