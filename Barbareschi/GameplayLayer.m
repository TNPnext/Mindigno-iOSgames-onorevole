//
//  GameplayLayer.m
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"
#import "Barbareschi.h"
#import "Constants.h"

@implementation GameplayLayer

- (void) initJoystickAndButtons {

    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    [joystickBase setPosition: ccp(64, 64)];
    [joystickBase setBackgroundSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:64]];
    [joystickBase setThumbSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:32]];
    
    joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    [joystick retain];
    
    [joystickBase setJoystick: joystick];
    
    [self addChild: joystickBase];
    
    //
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    [attackButtonBase setPosition: ccp(400, 64)];
    
    [attackButtonBase setDefaultSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 128) radius:32]];
    [attackButtonBase setPressSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:32]];
    
    attackButton = [[SneakyButton alloc] initWithRect: CGRectMake(0, 0, 128, 128)];
    [attackButton retain];
    [attackButton setIsToggleable: NO];
    
    [attackButtonBase setButton: attackButton];
    
    [self addChild: attackButtonBase];
}

- (void) dealloc {
 
    [joystick release];
    [attackButton release];
    
    [super dealloc];
}

- (id) init {
    
    self = [super init];
    if (self) {
        
        [self initJoystickAndButtons];
        
        //
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameplaySprite_default.plist"];
        spriteBatchNodeGamePlay = [CCSpriteBatchNode batchNodeWithFile:@"GameplaySprite_default.png"];
        
        [self addChild: spriteBatchNodeGamePlay];
        
        Barbareschi *barbareschi = [[Barbareschi alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"barba_10.png"]];
        
        [barbareschi setJoystick: joystick];
        [barbareschi setAttackButton: attackButton];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [barbareschi setScaleX:0.52f];
        [barbareschi setScaleY:0.52f];
        
        [barbareschi setPosition: ccp(screenSize.width/2, screenSize.height/2*0.57f)];
        //[barbareschi setAnchorPoint:CGPointMake(0, 1)];
        
        [barbareschi setCharacterHealth: 100];
        
        [spriteBatchNodeGamePlay addChild:barbareschi z:kBarbareschiSpriteZValue tag:kBarbareschiSpriteTagValue];
        
        //
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)deltaTime {
    
    CCArray *listOfGameObjects = [spriteBatchNodeGamePlay children];
    
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

@end
