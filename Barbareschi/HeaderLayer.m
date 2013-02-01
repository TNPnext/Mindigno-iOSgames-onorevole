//
//  HeaderLayer.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HeaderLayer.h"


@implementation HeaderLayer

- (id)init {

    self = [super init];
    if (self) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *headerImg = [CCSprite spriteWithFile:@"header.png"];
        
        [headerImg setAnchorPoint: ccp(0, 1)];
        [headerImg setPosition: ccp(0, screenSize.height)];
        
        [self addChild:headerImg];
    }
    
    return self;
}
@end
