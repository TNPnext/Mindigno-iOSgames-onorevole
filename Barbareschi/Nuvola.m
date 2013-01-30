//
//  Nuvola.m
//  Barbareschi
//
//  Created by Enrico on 28/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Nuvola.h"


@implementation Nuvola

-(void)changeState:(CharacterStates)newState {
    
    [self stopAllActions];
    
    CCAnimation *animation = nil;
    id action = nil;
    
    CharacterStates oldState = [self characterState];
    [self setPrevCharacterState: oldState];
    [self setCharacterState: newState];
    
    
    
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)spostatiConTempo:(ccTime)deltaTime {
    
    double scaledVelocityX = constVelocity * 480.0f;
    
    CGPoint oldPosition = [self position];
    //Muovo solo lungo x
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocityX * deltaTime,
                              oldPosition.y);
    
    [self setPosition: newPosition];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
    BOOL alLimite = [self checkAndClampSpritePosition];
    
    if (alLimite) {
        
        if (self.characterState == kStateGoLeft) {
            [self changeState: kStateGoRight];
            constVelocity = -constVelocity;
        
        } else if (characterState == kStateGoRight) {
            constVelocity = -constVelocity;
            [self changeState: kStateGoLeft];
        }
    }
    
    [self spostatiConTempo:deltaTime];
}

-(CGRect)adjustedBoundingBox {
    
    // Adjust the bouding box to the size of the sprite
    // without the transparent space
    CGRect boundingBox = [super boundingBox];
    
    return boundingBox;
}

//Override CCNODE per la visualizzazione dell'adjustedBoundingBox.
- (CGRect) boundingBox {
    
    CGRect ret = [self adjustedBoundingBox];
    return CC_RECT_PIXELS_TO_POINTS( ret );
}
//

- (void) dealloc {
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        self.gameObjectType = kNuvolaType;
        
        //
        
        self.characterState = kStateGoRight;
        constVelocity = CCRANDOM_0_1()*0.025 + 0.001;
        
        if (CCRANDOM_0_1() < 0.5) {
            self.characterState = kStateGoLeft;
            constVelocity = -constVelocity;
        }
        
    }
    return self;
}


@end
