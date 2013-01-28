//
//  Barbareschi.h
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCharacter.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"

#define kBarbareschi_fermoFrameName @"barbareschi_04.png"

@interface Barbareschi : GameCharacter {
    
    SneakyJoystick *joystick;
    SneakyButton *attackButton;
    
    //
    CCSpriteFrame *fermoFrame;
    CCAnimation *camminaAnimation;
    
    BOOL attaccaConPugno;
    CCAnimation *attaccaPugnoAnimation;
    CCAnimation *attaccaCalcioAnimation;
    
    CCAnimation *esultaAnimation;
}

@property (nonatomic, assign) SneakyJoystick *joystick;
@property (nonatomic, assign) SneakyButton *attackButton;

@property (nonatomic, retain) CCAnimation *camminaAnimation;
@property (nonatomic, retain) CCAnimation *attaccaPugnoAnimation;
@property (nonatomic, retain) CCAnimation *attaccaCalcioAnimation;

@property (nonatomic, retain) CCAnimation *esultaAnimation;

@end
