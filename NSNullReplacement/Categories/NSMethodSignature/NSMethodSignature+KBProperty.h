//
//  NSMethodSignature+KBProperty.h
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 09.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMethodSignature (KBProperty)

@property (nonatomic, assign, getter=isNilForwarded) BOOL nilForwarded;

@end
