//
//  GameScene.m
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "BackgroundLayer.h"
#import "GameplayLayer.h"
#import "HeaderLayer.h"

@implementation GameScene

- (id) init {

    self = [super init];
    if (self) {
        
        HeaderLayer *headerLayer = [HeaderLayer node];
        [self addChild: headerLayer z: kHeaderSpriteZValue];
        
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z: kBackgroundSpriteZValue];
        
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z: kGameplaySpriteBatchNodeZValue];
    }
    
    return self;
}

@end
