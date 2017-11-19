//
//  InstagramTests.m
//  InstahamTests
//
//  Created by Sneed, Brandon on 11/16/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Instagram.h"

#pragma mark - Testability\

@interface Instagram(Testable)
- (NSString * _Nonnull)apiEndpoint;
- (void)clearToken;
- (NSURL * _Nullable)buildURLForPath:(NSString * _Nonnull)path params:(NSArray<NSURLQueryItem *> * _Nullable)params token:(NSString * _Nonnull)token;
@end

#pragma mark - Test Suite

@interface InstagramTests : XCTestCase

@end

@implementation InstagramTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testURLBuilding {
    Instagram *ig = [Instagram new];
    
    NSURLQueryItem *dummy = [NSURLQueryItem queryItemWithName:@"booya" value:@"homeskillet"];
    NSURL *result = [ig buildURLForPath:@"media/1234" params:@[dummy] token:@"ABCDEF"];
    
    NSString *comparator = [ig.apiEndpoint stringByAppendingString:@"/media/1234?booya=homeskillet&access_token=ABCDEF"];
    
    XCTAssertTrue([[result absoluteString] isEqualToString:comparator]);
}

- (void)testTokenClearing {
    Instagram *ig = [Instagram new];
    ig.token = @"1234";
    [ig clearToken];
    XCTAssertNil(ig.token);
}

@end
