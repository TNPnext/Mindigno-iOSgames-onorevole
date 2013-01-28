//
//  BackgroundLayer.m
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

- (id) init {

    self = [super init];
    if (self) {
        
        CCSprite *backgroundImg = [CCSprite spriteWithFile:@"background.png"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        [backgroundImg setPosition: ccp(screenSize.width/2, screenSize.height/2)];
        
        [self addChild:backgroundImg z:kBackgroundSpriteZValue];
    }
    
    return self;
}

@end
