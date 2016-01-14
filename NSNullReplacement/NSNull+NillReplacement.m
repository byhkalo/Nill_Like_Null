//
//  NSNull+NillReplacement.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSNull+NillReplacement.h"
#import "KBObjectNull.h"

@implementation NSNull (NillReplacement)

+ (void)load {

}

- (instancetype)init
{
    return [NSNull null];
}


+ (instancetype)null
{
    // initialize sharedObject as nil (first call only)
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = (NSNull*)[[KBObjectNull alloc]init];;
    });
    // returns the same object each time
    return sharedObject;
}
@end
