//
//  Nuvola.m
//  Barbareschi
//
//  Created by Enrico on 28/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Nuvola.h"


@implementation Nuvola


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    
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

//TODO: da sistemare
-(CGRect)adjustedBoundingBox {
    
    // Adjust the bouding box to the size of the sprite
    // without the transparent space
    CGRect vikingBoundingBox = [self boundingBox];
    float xOffset;
    float xCropAmount = vikingBoundingBox.size.width * 0.5482f;
    float yCropAmount = vikingBoundingBox.size.height * 0.095f;
    
    if ([self flipX] == NO) {
        // Viking is facing to the rigth, back is on the left
        xOffset = vikingBoundingBox.size.width * 0.1566f;
    } else {
        // Viking is facing to the left; back is facing right
        xOffset = vikingBoundingBox.size.width * 0.4217f;
    }
    vikingBoundingBox =
    CGRectMake(vikingBoundingBox.origin.x + xOffset,
               vikingBoundingBox.origin.y,
               vikingBoundingBox.size.width - xCropAmount,
               vikingBoundingBox.size.height - yCropAmount);
    
    return vikingBoundingBox;
}

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
