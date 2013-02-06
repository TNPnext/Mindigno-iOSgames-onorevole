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
#import "GameManager.h"

@implementation GameplayLayer

- (void) initJoystickAndButtons {
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    float scaleFactor = 0.52f;
    if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        scaleFactor = 1.0f;
    }
    
    CGRect rectControl = CGRectMake(0, 0, 256, 256);
    CGSize sizeControl = CGSizeMake(128, 64);
    double radius = 56;
    CGPoint positionJoystick = ccp(96, 64);
    CGPoint positionAttack = ccp(400, 64);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        rectControl = CGRectMake(0, 0, 512, 512);
        sizeControl = CGSizeMake(256, 128);
        radius = 112;
        positionJoystick = ccp(192, 128);
        positionAttack = ccp(850, 128);
    
    } else if (screenSize.width == 568) {
        //iPhone 5
        positionAttack = ccp(480, 64);
    }

    joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    [joystickBase setPosition: positionJoystick];
    [joystickBase setBackgroundSprite: [ColoredSquareSprite squareWithColor:ccc4(255, 255, 255, 128) size: sizeControl]];
    [joystickBase setThumbSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:radius]];
    
    joystick = [[SneakyJoystick alloc] initWithRect:rectControl];
    [joystick retain];
    
    [joystickBase setJoystick: joystick];
    
    [joystickBase setScaleX: scaleFactor];
    [joystickBase setScaleY: scaleFactor];
    
    [self addChild: joystickBase z: kControlSpriteZValue];
    
    //
    
    attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    [attackButtonBase setPosition: positionAttack];
    
    [attackButtonBase setDefaultSprite: [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 150) radius:radius]];
    [attackButtonBase setPressSprite: [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 150) radius:radius]];
    
    attackButton = [[SneakyButton alloc] initWithRect: rectControl];
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
    
    [gameOverLayer release];
    
    [super dealloc];
}

- (id) init {
    
    self = [super init];
    if (self) {
        
        [self initJoystickAndButtons];
        
        //
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameplaySprite-ipad.plist"];
            spriteBatchNodeGamePlay = [CCSpriteBatchNode batchNodeWithFile:@"GameplaySprite-ipad.png"];
            
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameplaySprite.plist"];
            spriteBatchNodeGamePlay = [CCSpriteBatchNode batchNodeWithFile:@"GameplaySprite.png"];
        }
        
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
        
        //[barbareschi setScaleX:scaleFactor];
        //[barbareschi setScaleY:scaleFactor];
        
        [barbareschi setAnchorPoint:CGPointMake(0.5f, 0)];
        [barbareschi setPosition: ccp(screenSize.width/2, h_position)];
        
        [spriteBatchNodeGamePlay addChild:barbareschi z:kBarbareschiSpriteZValue tag:kBarbareschiSpriteTagValue];
    
        //
        
        Iena *iena = [[Iena alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kIena_fermoFrameName]];
        
        //[iena setScaleX:scaleFactor];
        //[iena setScaleY:scaleFactor];
        
        [iena setAnchorPoint:CGPointMake(0.5f, 0)];
        [iena setPosition: ccp(screenSize.width-56.0f, h_position)];
        
        [spriteBatchNodeGamePlay addChild:iena z: kGameplaySpriteBatchNodeZValue tag:kIenaSpriteTagValue];
        
        //
        
        Cameraman *cameraman = [[Cameraman alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kCameraman_fermoFrameName]];
        
        //[cameraman setScaleX:scaleFactor];
        //[cameraman setScaleY:scaleFactor];
        
        [cameraman setAnchorPoint:CGPointMake(0.5f, 0)];
        [cameraman setPosition: ccp(50.0f, h_position)];
        
        [spriteBatchNodeGamePlay addChild:cameraman z: kGameplaySpriteBatchNodeZValue tag:kCameramanSpriteTagValue];
        
        ///
        
        Nuvola *nuvolaGrande = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaGrandeFrameName]];
        
        //[nuvolaGrande setScaleX:scaleFactor];
        //[nuvolaGrande setScaleY:scaleFactor];
        
        [nuvolaGrande setPosition: ccp(screenSize.width*0.15f, screenSize.height*0.68f)];
        //[nuvolaGrande setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaGrande z: kNuvoleSpriteZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaMedia = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaMediaFrameName]];
        
        //[nuvolaMedia setScaleX:scaleFactor];
        //[nuvolaMedia setScaleY:scaleFactor];
        
        [nuvolaMedia setPosition: ccp(screenSize.width*0.55f, screenSize.height * 0.83f)];
        //[nuvolaMedia setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaMedia z: kNuvoleSpriteZValue tag:kNuvolaSpriteTagValue];
        
        //
        
        Nuvola *nuvolaPiccola = [[Nuvola alloc] initWithSpriteFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kNuvolaPiccolaFrameName]];
        
        //[nuvolaPiccola setScaleX:scaleFactor];
        //[nuvolaPiccola setScaleY:scaleFactor];
        
        [nuvolaPiccola setPosition: ccp(screenSize.width*0.85f, screenSize.height * 0.74f)];
        //[nuvolaPiccola setAnchorPoint:CGPointMake(0, 1)];
        
        [spriteBatchNodeGamePlay addChild:nuvolaPiccola z: kNuvoleSpriteZValue tag:kNuvolaSpriteTagValue];
        
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
        
        gameOverLayer = [[GameOverLayer node] retain];
        addedGameOverLayer = NO;
        
        /*
        //Per testare e visualizzare la schermata finale da subito
        [self addChild: gameOverLayer z:kFinalGameSpriteZValue];
        [self removeChild:joystickBase cleanup:YES];
        [self removeChild:attackButtonBase cleanup:YES];
        */
        
        //
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)deltaTime {
    
    BOOL giocoFinito = [[GameManager sharedGameManager] hasPlayerDied];
    if (giocoFinito && !addedGameOverLayer) {
        
        addedGameOverLayer = YES;
        
        [self addChild: gameOverLayer z:kFinalGameSpriteZValue];
        
        [self removeChild:joystickBase cleanup:YES];
        [self removeChild:attackButtonBase cleanup:YES];
    }
    
    CCArray *listOfGameObjects = [spriteBatchNodeGamePlay children];
    
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime];
    }
}

@end
