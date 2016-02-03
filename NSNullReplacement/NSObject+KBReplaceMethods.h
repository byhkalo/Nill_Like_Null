//
//  NSObject+Subclasses.h
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 21.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KBReplaceMethods)

+ (void)replaceClassMethodsOldSelector:(SEL)oldSelector byNewSelector:(SEL)newSelector;
+ (NSArray*)subclasses;

@end
