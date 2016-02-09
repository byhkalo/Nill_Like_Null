//
//  NSNullReplacementTests.m
//  NSNullReplacementTests
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSNull+KBNilReplacement.h"
#import "NSObject+KBReplaceMethods.h"
#import "KBObjectNull.h"

static IMP implementationNew = nil;
static IMP implementationAlloc = nil;
static IMP implementationNull = nil;
static IMP implementationAllocWithZone = nil;
static NSMutableArray *callingMethods = nil;

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
    
    XCTAssertTrue([null class] == [KBObjectNull class]);
    XCTAssertTrue([null class] == [NSNull class]);
}

- (void)testInjection {
    NSLog(@"start injection \n\n");
    callingMethods = [NSMutableArray array];
    
    [self logInjectionEnable];
    
    NSString *jsonString = @"{\"id\": null, \"name\":\"Aaa\"}";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    XCTAssertTrue([[dictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]);
    XCTAssertEqual(callingMethods.count, 1);
    XCTAssertTrue([callingMethods.firstObject isEqualToString:@"null"]);
    
    [self logInjectionDisable];
    
    [NSNull null];
    
    XCTAssertEqual(callingMethods.count, 1);
    
    NSLog(@"end of injection \n\n");
}

- (void)logInjectionEnable {
    if (!implementationNew) {
        Class class = [NSNull metaclass];
        
        implementationNew = [self replaceClassMethodWithoutParameters:@selector(new) class:[NSNull metaclass]];
        implementationAlloc = [self replaceClassMethodWithoutParameters:@selector(alloc) class:class];
        implementationNull = [self replaceClassMethodWithoutParameters:@selector(null) class:class];
        implementationAllocWithZone = [self replaceClassMethodAllocWithZoneInClass:class];
    }
}

- (void)logInjectionDisable {
    if (implementationNew) {
        Class class = [NSNull metaclass];
        
        [NSNull replaceMethod:@selector(new) inClass:class byIMP:implementationNew isResetIMP:YES];
        [NSNull replaceMethod:@selector(alloc) inClass:class byIMP:implementationAlloc isResetIMP:YES];
        [NSNull replaceMethod:@selector(null) inClass:class byIMP:implementationNull isResetIMP:YES];
        [NSNull replaceMethod:@selector(allocWithZone:) inClass:class byIMP:implementationAllocWithZone isResetIMP:YES];
    }
}

- (IMP)replaceClassMethodWithoutParameters:(SEL)selector class:(Class)class{
    IMP implementation = [class instanceMethodForSelector:selector];
    
    id block = ^(id blockObject, SEL blockSelector) {
        NSString *stringSelector = NSStringFromSelector(selector);
        NSLog(@"Method %@ call", stringSelector);
        [callingMethods addObject:stringSelector];
        
        return ((id(*)(id, SEL))implementation)(blockObject, selector);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    [[NSNull class] replaceMethod:selector inClass:class byIMP:blockIMP isResetIMP:NO];
    
    return implementation;
}

- (IMP)replaceClassMethodAllocWithZoneInClass:(Class)class {
    SEL selector = @selector(allocWithZone:);
    IMP implementation = [class instanceMethodForSelector:selector];
    
    id block = ^(id blockObject, SEL blockSelector, NSZone *zone) {
        NSString *stringSelector = NSStringFromSelector(selector);
        NSLog(@"Method %s call", sel_getName(selector));
        [callingMethods addObject:stringSelector];
        
        return ((id(*)(id, SEL, NSZone *))implementation)(blockObject, blockSelector, zone);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    [NSNull replaceMethod:selector inClass:class byIMP:blockIMP isResetIMP:NO];
    
    return implementation;
}


@end
