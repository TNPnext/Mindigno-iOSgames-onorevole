//
//  GameplayLayer.h
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "ColoredSquareSprite.h"

@interface GameplayLayer : CCLayer {
    
    SneakyJoystick *joystick;
    SneakyButton *attackButton;
    
    //
    
    CCSpriteBatchNode *spriteBatchNodeGamePlay;
}

@end
