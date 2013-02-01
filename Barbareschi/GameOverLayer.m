//
//  GameOverLayer.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"


@implementation GameOverLayer

-(id)init {
    
    self = [super init];
    if (self) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *trasparent = [CCSprite spriteWithFile:@"BlackTrasparent.png"];
        [trasparent setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild: trasparent];
        
        //
        
        float scaleFactor = 0.52f;
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            scaleFactor = 1.0f;
        }

        CCSprite *barbareschi = [CCSprite spriteWithFile: @"Fine_barbareschi.png"];
        [barbareschi setPosition:ccp(screenSize.width * 0.35f, screenSize.height * 0.4f)];
        [self addChild: barbareschi];
        
        [barbareschi setScaleX: scaleFactor];
        [barbareschi setScaleY: scaleFactor];
        
        id scaleUp = [CCScaleTo actionWithDuration:0.5f scale: scaleFactor + 0.05];
        id scaleDown = [CCScaleTo actionWithDuration:0.5f scale: scaleFactor];
        
        [barbareschi runAction:
         [CCRepeatForever actionWithAction:
          [CCSequence actions: scaleUp, scaleDown, nil]]];
        
    }
    
    return self;
}
@end
