//
//  MainMenuScene.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"
#import "BackgroundLayer.h"
#import "HeaderLayer.h"

@implementation MainMenuScene

- (id)init {

    self = [super init];
    if (self) {
        
        HeaderLayer *headerLayer = [HeaderLayer node];
        [self addChild: headerLayer z: kHeaderSpriteZValue];
        
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild: backgroundLayer z: kBackgroundSpriteZValue];
        
        MainMenuLayer *mainMenuLayer = [MainMenuLayer node];
        [self addChild: mainMenuLayer z: kGameplaySpriteBatchNodeZValue];
    }
    
    return self;
}

@end
