//
//  ConversionTests.m
//  InstahamTests
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Conversion.h"

@interface ConversionTests : XCTestCase

@end

@implementation ConversionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConversion {
    /*
     Normally i wouldn't write tests for this unless i was required to hit a certain coverage numbers.
     I'd usually just test things that felt like they could go wrong easily.
     */
    NSObject *o = [[NSObject alloc] init];
    XCTAssertNil([o stringValue]);
    
    NSObject *n = @15;
    // you'd think this would fail, but NSNumber has a 'stringValue' that takes precedent over the NSObject extension.
    XCTAssertNotNil([n stringValue]);
    XCTAssertTrue([[n stringValue] isEqualToString:@"15"]);
    XCTAssertNotNil([n numberValue]);
    XCTAssertTrue([n numberValue].intValue == 15);
    
    NSString *s = @"blah";
    XCTAssertNil([s numberValue]);
    XCTAssertNotNil([s stringValue]);
    XCTAssertTrue([[s stringValue] isEqualToString:@"blah"]);
    
}


@end
