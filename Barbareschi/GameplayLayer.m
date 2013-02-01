//
//  GameplayLayer.m
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"
#import "Barbareschi.h"
#import "Iena.h"
#import "Cameraman.h"
#import "Nuvola.h"
#import "Lifebar.h"
#import "Constants.h"

@implementation GameplayLayer

- (void) initJoystickAndButtons {
    
    float scaleFactor = 0.52f;
    if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        scaleFactor = 1.0f;
    }

    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    [joystickBase setPosition: ccp(96, 64)];
    [joystickBase setBackgroundSprite: [ColoredSquareSprite squareWithColor:ccc4(255, 255, 255, 128) size:CGSizeMake(128, 64)]];
    //[joystickBase setBackgroundSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:64]];
    [joystickBase setThumbSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:56]];
    
    joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 256, 256)];
    [joystick retain];
    
    [joystickBase setJoystick: joystick];
    
    [joystickBase setScaleX: scaleFactor];
    [joystickBase setScaleY: scaleFactor];
    
    [self addChild: joystickBase z: kControlSpriteZValue];
    
    //
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    [attackButtonBase setPosition: ccp(400, 64)];
    
    [attackButtonBase setDefaultSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 150) radius:32]];
    [attackButtonBase setPressSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:56]];
    
    attackButton = [[SneakyButton alloc] initWithRect: CGRectMake(0, 0, 256, 256)];
    [attackButton retain];
    [attackButton setIsToggleable: NO];
    
    [attackButtonBase setButton: attackButton];
    
    [attackButtonBase setScaleX: scaleFactor];
    [attackButtonBase setScaleY: scaleFactor];
    
    [self addChild: attackButtonBase z: kControlSpriteZValue];
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
        
        [self addChild: spriteBatchNodeGamePlay z: kGameplaySpriteBatchNodeZValue];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float h_position = screenSize.height * 0.055f;
        
        float scaleFactor = 0.52f;
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            scaleFactor = 1.0f;
        }
        
        //
        
        Barbareschi *barbareschi = [[Barbareschi alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kBarbareschi_fermoFrameName]];
        
        [barbareschi setJoystick: joystick];
        [barbareschi setAttackButton: attackButton];
        
        [barbareschi setScaleX:scaleFactor];
        [barbareschi setScaleY:scaleFactor];
        
        [barbareschi setAnchorPoint:CGPointMake(0.5f, 0)];
        [barbareschi setPosition: ccp(screenSize.width/2, h_position)];
        
        [spriteBatchNodeGamePlay addChild:barbareschi z:kBarbareschiSpriteZValue tag:kBarbareschiSpriteTagValue];
    
        //
        
        Iena *iena = [[Iena alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kIena_fermoFrameName]];
        
        [iena setScaleX:scaleFactor];
        [iena setScaleY:scaleFactor];
        
        [iena setAnchorPoint:CGPointMake(0.5f, 0)];
        [iena setPosition: ccp(screenSize.width-56.0f, h_position)];
        
        [spriteBatchNodeGamePlay addChild:iena z: kGameplaySpriteBatchNodeZValue tag:kIenaSpriteTagValue];
        
        //
        
        Cameraman *cameraman = [[Cameraman alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kCameraman_fermoFrameName]];
        
        [cameraman setScaleX:scaleFactor];
        [cameraman setScaleY:scaleFactor];
        
        [cameraman setAnchorPoint:CGPointMake(0.5f, 0)];
        [cameraman setPosition: ccp(50.0f, h_position)];
        
        [spriteBatchNodeGamePlay addChild:cameraman z: kGameplaySpriteBatchNodeZValue tag:kCameramanSpriteTagValue];
        
        ///
        
        Nuvola *nuvolaGrande = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaGrandeFrameName]];
        
        [nuvolaGrande setScaleX:scaleFactor];
        [nuvolaGrande setScaleY:scaleFactor];
        
        [nuvolaGrande setPosition: ccp(screenSize.width*0.15f, screenSize.height*0.63f)];
        //[nuvolaGrande setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaGrande z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaMedia = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaMediaFrameName]];
        
        [nuvolaMedia setScaleX:scaleFactor];
        [nuvolaMedia setScaleY:scaleFactor];
        
        [nuvolaMedia setPosition: ccp(screenSize.width*0.55f, screenSize.height * 0.83f)];
        //[nuvolaMedia setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaMedia z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaPiccola = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaPiccolaFrameName]];
        
        [nuvolaPiccola setScaleX:scaleFactor];
        [nuvolaPiccola setScaleY:scaleFactor];
        
        [nuvolaPiccola setPosition: ccp(screenSize.width*0.85f, screenSize.height * 0.74f)];
        //[nuvolaPiccola setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaPiccola z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        ///
        
        Lifebar *lifeBarCameraman = [[Lifebar alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"lifebar.png"]];

        [lifeBarCameraman setAnchorPoint: ccp(0, 0)];
        [lifeBarCameraman setPosition: ccp(2, 2)];
        
        [self addChild:lifeBarCameraman z:kControlSpriteZValue tag:kLifebarCameramanSpriteTagValue];
        
        //
        
        Lifebar *lifeBarIena = [[Lifebar alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"lifebar.png"]];
        
        [lifeBarIena setAnchorPoint: ccp(1, 0)];
        [lifeBarIena setPosition: ccp(screenSize.width-2, 2)];
        
        [self addChild:lifeBarIena z:kControlSpriteZValue tag:kLifebarIenaSpriteTagValue];
        
        //
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)deltaTime {
    
    CCArray *listOfGameObjects = [spriteBatchNodeGamePlay children];
    
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime];
    }
}

@end
