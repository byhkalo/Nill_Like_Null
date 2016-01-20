//
//  NSNullReplacementTests.m
//  NSNullReplacementTests
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

@interface NSNullReplacementTests : XCTestCase {
   
}

@end

@implementation NSNullReplacementTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReplacementNull {
    
    NSNull* null = [NSNull null];
    
    XCTAssertFalse([null performSelector:@selector(loadView)], @"Must sey NO");
    XCTAssertNoThrow([(id)null loadView], @"Nustn't call throw");
    
    XCTAssertFalse([null performSelector:@selector(view)], @"Must sey NO");
    XCTAssertNoThrow([(id)null view], @"No throw when call method");
    XCTAssertNil([(id)null view], @"Must returmn nil");
    
    XCTAssertFalse([null performSelector:@selector(count)], @"Must sey NO");
    XCTAssertTrue([(id)null count] == 0, @"Must return zero");
    
    XCTAssertTrue([null isEqual:nil], @"Must be equal to nil (mustn't use ==)");
    XCTAssertTrue([null isKindOfClass:[NSNull class]], @"Class must be like NSNull Class");
    XCTAssertTrue([[NSNull null] isEqual:[NSNull null]], @"Must be equal");
    XCTAssertFalse([null isEqual:[NSObject new]], @"Mustn't be equal");
    XCTAssertTrue([(id)null hash] == [[NSNull null]hash], @"Must sey YES");
    XCTAssertTrue([null isEqual:[[NSNull alloc]init]], @"Must be equal");
    XCTAssertTrue([null isEqual:[NSNull new]], @"Must be equal");
    
    XCTAssertTrue(null == [[NSNull alloc]init], @"Must be equal");
    XCTAssertTrue(null == [NSNull new], @"Must be equal");
    
    XCTAssertTrue([NSNull new] == [NSNull new]);
    
//    XCTAssertTrue([null class] == [NSNull class]);
//    XCTAssertTrue(CGRectIsNull([[NSNull null] valueForKey:@"frame"]) , @"Must return zero");
    
    
}

@end
