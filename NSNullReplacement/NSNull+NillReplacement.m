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

+(instancetype)alloc {
    return (NSNull*)[KBObjectNull null];
}



+ (instancetype)null
{
    return (NSNull*)[KBObjectNull null];
}
@end
