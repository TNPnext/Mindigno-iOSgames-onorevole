//
//  MainMenuLayer.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameManager.h"

@implementation MainMenuLayer

- (void) playGameScene {
    
    [[GameManager sharedGameManager] runSceneWithID:kGameLevel1];
}

-(void)playPostIntro {
    PLAYSOUNDEFFECT(RAGGIUNGIAMO_IN_SICILIA);
}

-(void)playIntro {
    PLAYSOUNDEFFECT(INTRO);
}

-(void)preGameScene {
    
    id playSound = [CCCallFunc actionWithTarget:self selector:@selector(playPostIntro)];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    id moveAction = [CCMoveTo actionWithDuration:1.0f position:ccp(screenSize.width * 2.0f, screenSize.height / 1.45f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    
    id playGame = [CCCallFunc actionWithTarget:self selector:@selector(playGameScene)];
    
    id sequenceAction = [CCSequence actions: playSound, moveEffect, playGame, nil];
    
    [mainMenu runAction:sequenceAction];
}

-(void)displayMainMenu {
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItemImage *playGameButton = [CCMenuItemImage
                                       itemFromNormalImage:@"PlayButtonNormal.png"
                                       selectedImage:@"PlayButtonSelected.png"
                                       disabledImage:nil
                                       target:self
                                       selector:@selector(preGameScene)];
    [playGameButton setScaleX: 0.52];
    [playGameButton setScaleY: 0.52];
    
    mainMenu = [CCMenu menuWithItems: playGameButton ,nil];
    
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 1.45f)];
    
    id moveAction = [CCMoveTo actionWithDuration:1.2f position:ccp(screenSize.width * 0.85f, screenSize.height/1.45f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id playSound = [CCCallFunc actionWithTarget:self selector:@selector(playIntro)];
    
    id sequenceAction = [CCSequence actions: moveEffect, playSound, nil];
    
    [mainMenu runAction:sequenceAction];
    
    [self addChild:mainMenu];
}


- (id)init {
    
    self = [super init];
    if (self) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        float scaleFactor = 0.52f;
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            scaleFactor = 1.0f;
        }
        
        //
        
        CCSprite *barbareschi = [CCSprite spriteWithFile: @"Inizio_barbareschi.png"];
        [barbareschi setPosition:ccp(screenSize.width * 0.35f, screenSize.height * 0.4f)];
        [self addChild: barbareschi];
        
        [barbareschi setScaleX: scaleFactor];
        [barbareschi setScaleY: scaleFactor];
        
        id scaleUp = [CCScaleTo actionWithDuration:0.5f scale: scaleFactor + 0.05];
        id scaleDown = [CCScaleTo actionWithDuration:0.5f scale: scaleFactor];
        
        [barbareschi runAction:
            [CCRepeatForever actionWithAction:
                [CCSequence actions: scaleUp, scaleDown, nil]]];
        
        //
        
        [self displayMainMenu];
    }
    
    return self;
}

@end
