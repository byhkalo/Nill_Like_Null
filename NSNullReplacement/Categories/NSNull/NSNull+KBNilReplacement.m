//
//  NSNull+NillReplacement.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSNull+KBNilReplacement.h"
#import "NSObject+KBReplaceMethods.h"
#import "KBObjectNull.h"
#import <objc/runtime.h>

typedef id(^KBBlockWithImplementation)(IMP implementation);

@implementation NSNull (KBNilReplacement)

#pragma mark -
#pragma mark Replacing Methods -

+ (void)load {
    [self replaceClassMethodsOldSelectorImplementation:@selector(allocWithZone:) byNewSelector:@selector(newAllocWithZone:)];
    [self replaceClassMethodsOldSelectorImplementation:@selector(null) byNewSelector:@selector(newNull)];
}

+ (instancetype)newAllocWithZone:(struct _NSZone *)zone {
    return (self  == [NSNull class]) ? [KBObjectNull sharedObject] : [super allocWithZone:0];
}

+ (id)newNull {
    return [KBObjectNull sharedObject];
}

@end
