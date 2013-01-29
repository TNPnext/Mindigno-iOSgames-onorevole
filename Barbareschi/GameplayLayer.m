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
#import "Constants.h"

@implementation GameplayLayer

- (void) initJoystickAndButtons {

    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    [joystickBase setPosition: ccp(96, 64)];
    [joystickBase setBackgroundSprite: [ColoredSquareSprite squareWithColor:ccc4(255, 255, 255, 128) size:CGSizeMake(64, 32)]];
    //[joystickBase setBackgroundSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:64]];
    [joystickBase setThumbSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:32]];
    
    joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    [joystick retain];
    
    [joystickBase setJoystick: joystick];
    
    [self addChild: joystickBase z: kControlSpriteZValue];
    
    //
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    [attackButtonBase setPosition: ccp(400, 64)];
    
    [attackButtonBase setDefaultSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 150) radius:32]];
    [attackButtonBase setPressSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:32]];
    
    attackButton = [[SneakyButton alloc] initWithRect: CGRectMake(0, 0, 128, 128)];
    [attackButton retain];
    [attackButton setIsToggleable: NO];
    
    [attackButtonBase setButton: attackButton];
    
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
        
        [nuvolaGrande setPosition: ccp(screenSize.width*0.15f, screenSize.height*0.67f)];
        //[nuvolaGrande setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaGrande z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaMedia = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaMediaFrameName]];
        
        [nuvolaMedia setScaleX:scaleFactor];
        [nuvolaMedia setScaleY:scaleFactor];
        
        [nuvolaMedia setPosition: ccp(screenSize.width*0.55f, screenSize.height * 0.87f)];
        //[nuvolaMedia setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaMedia z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaPiccola = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaPiccolaFrameName]];
        
        [nuvolaPiccola setScaleX:scaleFactor];
        [nuvolaPiccola setScaleY:scaleFactor];
        
        [nuvolaPiccola setPosition: ccp(screenSize.width*0.85f, screenSize.height * 0.65f)];
        //[nuvolaPiccola setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaPiccola z: kGameplaySpriteBatchNodeZValue tag:kNuvolaSpriteTagValue];
        
        ///
        
        lifeBarCameraman = [CCSprite spriteWithFile:@"Bar.png"];
        [lifeBarCameraman setAnchorPoint: ccp(0, 1)];
        [lifeBarCameraman setPosition: ccp(5, screenSize.height-5)];
        
        [lifeBarCameraman setScaleX:60];
        [lifeBarCameraman setScaleY:0.5];
        
        [self addChild:lifeBarCameraman z:kControlSpriteZValue];
        
        //
        
        lifeBarIena = [CCSprite spriteWithFile:@"Bar.png"];
        [lifeBarIena setAnchorPoint: ccp(1, 1)];
        [lifeBarIena setPosition: ccp(screenSize.width-5, screenSize.height-5)];
        
        [lifeBarIena setScaleX:60];
        [lifeBarIena setScaleY:0.5];
        
        [self addChild:lifeBarIena z:kControlSpriteZValue];
        
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
