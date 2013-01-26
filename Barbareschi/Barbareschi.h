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

@interface Barbareschi : GameCharacter {
    
    SneakyJoystick *joystick;
    SneakyButton *attackButton;
    
    //
    CCSpriteFrame *standingFrame;
    
    CCAnimation *walkingAnimation;
    
    BOOL attackWithPugno;
    CCAnimation *attackPugnoAnimation;
    CCAnimation *attackCalcioAnimation;
}

@property (nonatomic, retain) CCAnimation *walkingAnimation;
@property (nonatomic, retain) CCAnimation *attackPugnoAnimation;
@property (nonatomic, retain) CCAnimation *attackCalcioAnimation;

@property (nonatomic, assign) SneakyJoystick *joystick;
@property (nonatomic, assign) SneakyButton *attackButton;

@end
