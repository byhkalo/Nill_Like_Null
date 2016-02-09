//
//  NSMethodSignature+KBProperty.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 09.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSMethodSignature+KBProperty.h"
#import <objc/runtime.h>
static const NSString * kKBMethodSignatureNilForwarded    = @"kKBMethodSignatureNilForwarded";

@implementation NSMethodSignature (KBProperty)

- (void)setNilForwarded:(BOOL)nilForwarded {
    objc_setAssociatedObject(self, (__bridge const void *)(kKBMethodSignatureNilForwarded), @(nilForwarded), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isNilForwarded {
    return objc_getAssociatedObject(self, (__bridge const void *)(kKBMethodSignatureNilForwarded));
}

@end
