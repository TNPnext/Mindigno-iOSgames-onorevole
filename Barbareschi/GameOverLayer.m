//
//  GameOverLayer.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameManager.h"

@implementation GameOverLayer

-(void)buttonIndignatiPressed {
    
    CCLOG(@"Indignati button pressed");
    [[GameManager sharedGameManager] openSiteWithLinkType: kLinkTypeMindignoSite];
}

-(void)buttonGoToMenuPressed {
    
    CCLOG(@"Go to menu button pressed");
    [[GameManager sharedGameManager] runSceneWithID: kMainMenuScene];
}

-(id)init {
    
    self = [super init];
    if (self) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *trasparent;
        if (screenSize.width == 568) {
            //iPhone 5
            trasparent = [CCSprite spriteWithFile:@"BlackTrasparent-iphone5.png"];
        } else {
            trasparent = [CCSprite spriteWithFile:@"BlackTrasparent.png"];
        }
        
        [trasparent setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild: trasparent];
        
        //
        
        float scaleFactor = 0.5f;
        float scaleFactorButtonIndignati = 0.85f;
        float scaleFactorButtonMenu = 0.25f;
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            scaleFactor = scaleFactor * 2.0;
            scaleFactorButtonIndignati = scaleFactorButtonIndignati * 2.0;
            scaleFactorButtonMenu = scaleFactorButtonMenu * 2.0;
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
        
        ///
        
        CCLabelTTF *fraseMagica = [CCLabelTTF
                                   labelWithString:@"Pensi che le cose non possano cambiare?\nAnche tu puoi fare la differenza."
                                   dimensions:CGSizeMake(200, 100)
                                   alignment:UITextAlignmentCenter
                                   lineBreakMode:UILineBreakModeWordWrap
                                   fontName:@"Arial" fontSize:18];
        
        [fraseMagica setPosition: ccp(screenSize.width * 0.78, screenSize.height * 0.65)];
        [self addChild:fraseMagica];
        
        //
        
        CCMenuItemImage *indignatiButton = [CCMenuItemImage
                                            itemFromNormalImage:@"IndignatiButton.png"
                                            selectedImage:@"IndignatiButton.png"
                                            disabledImage:nil
                                            target:self
                                            selector:@selector(buttonIndignatiPressed)];
        
        [indignatiButton setScaleX: scaleFactorButtonIndignati];
        [indignatiButton setScaleY: scaleFactorButtonIndignati];
        
        CCMenu *menuIndignati = [CCMenu menuWithItems: indignatiButton, nil];
        [menuIndignati setPosition: ccp(screenSize.width * 2, screenSize.height/2.4f)];
        [self addChild:menuIndignati];
        
        id moveAction = [CCMoveTo actionWithDuration:1.0f position:ccp(screenSize.width * 0.78f, screenSize.height/2.4f)];
        id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
        //id playSound = [CCCallFunc actionWithTarget:self selector:@selector(playIntro)];
        id sequenceAction = [CCSequence actions: moveEffect, nil];
        
        [menuIndignati runAction:sequenceAction];
        
        //
        
        CCMenuItemImage *menuButtonBack = [CCMenuItemImage
                                           itemFromNormalImage:@"PlayButtonNormal.png"
                                           selectedImage:@"PlayButtonSelected.png"
                                           disabledImage:nil
                                           target:self
                                           selector:@selector(buttonGoToMenuPressed)];
        
        [menuButtonBack setScaleX: scaleFactorButtonMenu];
        [menuButtonBack setScaleY: scaleFactorButtonMenu];
        
        CCMenu *menuButton = [CCMenu menuWithItems: menuButtonBack, nil];
        [menuButton setPosition: ccp(screenSize.width * -0.10f, screenSize.height * 0.20f)];
        [self addChild:menuButton];

        moveAction = [CCMoveTo actionWithDuration:1.5f position:ccp(screenSize.width * 0.10f, screenSize.height * 0.20f)];
        moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
        sequenceAction = [CCSequence actions: moveEffect, nil];
        
        [menuButton runAction:sequenceAction];
        
        //
        
        /*
        CCMenuItemImage *shareButton = [CCMenuItemImage
                                        itemFromNormalImage:@"share.png"
                                        selectedImage:@"share.png"
                                        disabledImage:nil
                                        target:self
                                        selector:@selector(buttonSharePressed)];
        
        [shareButton setScaleX: 0.25];
        [shareButton setScaleY: 0.25];
        
        CCMenu *menuShare = [CCMenu menuWithItems: shareButton, nil];
        [menuShare setPosition: ccp(screenSize.width * 0.88f, screenSize.height * 0.20f)];
        [self addChild:menuShare];
         */
        
        //
        
        /*
        CCLabelTTF *labelPunteggio = [CCLabelTTF labelWithString:@"108 pt" fontName:@"Arial" fontSize:28];
        
        [labelPunteggio setPosition: ccp(screenSize.width * 0.72, screenSize.height * 0.20)];
        [self addChild:labelPunteggio];
        */
    }
    
    return self;
}
@end
