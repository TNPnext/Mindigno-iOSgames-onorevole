//
//  Nuvola.m
//  Barbareschi
//
//  Created by Enrico on 28/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Nuvola.h"


@implementation Nuvola


-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    
    /*
     for (GameCharacter *character in listOfGameObjects) {
     
     // No need to check collision with one's self
     if ([character tag] == kBarbareschiSpriteTagValue)
     continue;
     
     CGRect characterBox = [character adjustedBoundingBox];
     
     if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
     
     // Remove the PhaserBullet from the scene
     if ([character gameObjectType] == kIenaType) {
     
     //[self changeState:kStateTakingDamage];
     //[character changeState:kStateDead];
     
     } else if ([character gameObjectType] == kCameramanType) {
     
     //[self changeState:kStateIdle];
     // Remove the Mallet from the scene
     //[character changeState:kStateDead];
     
     }
     }
     }
     */
    
    [self checkAndClampSpritePosition];
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
        
    }
    return self;
}


@end
