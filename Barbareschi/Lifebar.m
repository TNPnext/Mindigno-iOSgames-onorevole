//
//  Lifebar.m
//  Barbareschi
//
//  Created by Enrico on 31/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Lifebar.h"


@implementation Lifebar

- (void) dealloc {

    [super dealloc];
}

- (id)init {

    self = [super init];
    if (self) {
        
        length = 60.0;
        
        [self setScaleX: length];
        [self setScaleY:0.4];
        
    }
    
    return self;
}

//Delta va da 100 a 0;
- (void)setLife:(double)life {

    double newValue = length/100.0 * life;
    
    if (newValue < 0) {
        newValue = 0;
    }
    
    [self setScaleX: newValue];
}

@end
