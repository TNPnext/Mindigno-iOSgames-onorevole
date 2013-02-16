//
//  GameOverLayer.m
//  Barbareschi
//
//  Created by Enrico on 01/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameManager.h"
#import "Flurry.h"
#import "AppDelegate.h"

@implementation GameOverLayer

-(void)buttonIndignatiPressed {
    
    [Flurry logEvent:@"Indignati button pressed" timed:YES];
    CCLOG(@"Indignati button pressed");
    
    [[GameManager sharedGameManager] openSiteWithLinkType: kLinkTypeMindignoSite];
}

-(void)buttonGoToMenuPressed {
    
    [Flurry logEvent:@"Go to menu button pressed" timed:YES];
    CCLOG(@"Go to menu button pressed");
    
    [[GameManager sharedGameManager] runSceneWithID: kMainMenuScene];
}

-(void)buttonSharePressed {

    [Flurry logEvent:@"Share button pressed" timed:YES];
    CCLOG(@"Share button pressed");
    
    int punti = [[GameManager sharedGameManager] points];
    NSString *textToShare = [NSString stringWithFormat:@"Ho fatto %d punti a questa app: %@", punti, APP_URL];
    UIImage *imageToShare = [UIImage imageNamed:@"Icon.png"];
    NSURL *urlToShare = [NSURL URLWithString:APP_URL];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities: nil];
    
    //This is an array of excluded activities to appear on the UIActivityViewController
    activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RootViewController* controller = [appDelegate viewController];
    [controller presentViewController:activityVC animated:YES completion:nil];
}

-(id)init {
    
    self = [super init];
    if (self) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *trasparent;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            trasparent = [CCSprite spriteWithFile:@"BlackTrasparent-ipad.png"];
            
        } else {
        
            if (screenSize.width == 568) {
                //iPhone 5
                trasparent = [CCSprite spriteWithFile:@"BlackTrasparent-iphone5.png"];
            } else {
                trasparent = [CCSprite spriteWithFile:@"BlackTrasparent.png"];
            }
        }
        
        [trasparent setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild: trasparent];
        
        //
        
        float scaleFactor = 0.5f;
        float scaleFactorButtonIndignati = 0.85f;
        float scaleFactorButtonMenu = 0.25f;
        
        CGSize sizeFrase = CGSizeMake(200, 100);
        int fontSize = 18;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            scaleFactor += 0.60f;
            scaleFactorButtonIndignati += 0.85f;
            scaleFactorButtonMenu += 0.25f;
            
            fontSize = 36;
            sizeFrase = CGSizeMake(400, 200);
        }
        
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
                                   dimensions:sizeFrase
                                   alignment:UITextAlignmentCenter
                                   lineBreakMode:UILineBreakModeWordWrap
                                   fontName:@"Arial" fontSize:fontSize];
        
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
        
        CCCallBlock* completion = [CCCallBlock actionWithBlock:^{
            [CCTouchDispatcher sharedDispatcher].dispatchEvents = YES;
        }];
        
        id sequenceAction = [CCSequence actions: moveEffect, completion, nil];
        
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

        moveAction = [CCMoveTo actionWithDuration:1.5f position:ccp(screenSize.width * 0.082f, screenSize.height * 0.20f)];
        moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
        sequenceAction = [CCSequence actions: moveEffect, nil];
        
        [menuButton runAction:sequenceAction];
        
        //
        
        CCMenuItemImage *shareButton = [CCMenuItemImage
                                        itemFromNormalImage:@"ShareButtonNormal.png"
                                        selectedImage:@"ShareButtonSelected.png"
                                        disabledImage:nil
                                        target:self
                                        selector:@selector(buttonSharePressed)];
        
        [shareButton setScaleX: scaleFactorButtonMenu];
        [shareButton setScaleY: scaleFactorButtonMenu];
        
        CCMenu *menuShare = [CCMenu menuWithItems: shareButton, nil];
        [menuShare setPosition: ccp(screenSize.width * 0.88f, screenSize.height * 0.20f)];
        [self addChild:menuShare];
    }
    
    return self;
}
@end
