//
//  PointTable.m
//  Barbareschi
//
//  Created by Enrico on 15/02/13.
//
//

#import "PointTable.h"

@implementation PointTable

- (void) dealloc {
    
    [super dealloc];
}

- (id) init {

    if (self = [super init]) {
        
    }
    return self;
}

- (void) setStringWithAnimation:(NSString*)string {

    [self setString:string];
    
    id scaleUp = [CCScaleTo actionWithDuration:0.1f scale: 1.25];
    id scaleDown = [CCScaleTo actionWithDuration:0.05f scale: 1.0];
    
    [self runAction: [CCSequence actions: scaleUp, scaleDown, nil]];
}

@end
