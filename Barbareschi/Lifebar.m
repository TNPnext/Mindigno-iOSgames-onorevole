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
        double heightScaling = 0.4;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            length = 120;
            heightScaling += 0.65;
        }
        
        //Se è retina (quindi iphone 5, 4 e 4S
        if ([[CCDirector sharedDirector] enableRetinaDisplay: YES]) {
            length = length * 2;
            heightScaling = heightScaling * 2;
        }
        
        [self setScaleX: length];
        [self setScaleY: heightScaling];
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
