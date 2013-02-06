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
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundImg;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImg = [CCSprite spriteWithFile:@"background-ipad.png"];
            
        } else {
            
            //iPhone 5
            if (screenSize.width == 568) {
                backgroundImg = [CCSprite spriteWithFile:@"background-iphone5.png"];
            } else {
                backgroundImg = [CCSprite spriteWithFile:@"background.png"];
            }
        }
        
        [backgroundImg setPosition: ccp(screenSize.width/2, screenSize.height/2)];
        
        [self addChild:backgroundImg];
    }
    
    return self;
}

@end
