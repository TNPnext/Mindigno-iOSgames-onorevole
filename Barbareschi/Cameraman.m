//
//  Cameraman.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Cameraman.h"


@implementation Cameraman

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    GameCharacter *barbareschi = (GameCharacter*)[[self parent] getChildByTag: kBarbareschiSpriteTagValue];
    
    if (barbareschi.characterState == kStateEsulta)
        return; // Nothing to do.
    
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
    
    if (characterState == kStateFermo) {
		// Shrink the bounding box to 56% of height
        // 88 pixels on top on iPad
		vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x,
									   vikingBoundingBox.origin.y,
									   vikingBoundingBox.size.width,
									   vikingBoundingBox.size.height * 0.56f);
	}
    
    return vikingBoundingBox;
}

-(void)initAnimations {
    
    CCSpriteFrame *fermoFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kCameraman_fermoFrameName];
    CCSpriteFrame *fermo_feritaFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kCameraman_fermo_feritoFrameName];
    
    CCAnimation *camminaAnimation = [self loadPlistForAnimationWithName:@"camminaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *indietreggiaAnimation = [self loadPlistForAnimationWithName:@"indietreggiaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *pre_colpitoAnimation = [self loadPlistForAnimationWithName:@"preColpitoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpito_pugnoAnimation = [self loadPlistForAnimationWithName:@"colpitoPugnoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpito_calcioAnimation = [self loadPlistForAnimationWithName:@"colpitoCalcioAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *minacciatoAnimation = [self loadPlistForAnimationWithName:@"minacciatoAnimation" andClassName:NSStringFromClass([self class])];
    
    CCAnimation *cammina_feritoAnimation = [self loadPlistForAnimationWithName:@"camminaFeritoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *indietreggia_feritoAnimation = [self loadPlistForAnimationWithName:@"indietreggiaFeritoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *pre_colpito_feritoAnimation = [self loadPlistForAnimationWithName:@"preColpitoFeritoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpito_pugno_feritoAnimation = [self loadPlistForAnimationWithName:@"colpitoPugnoFeritoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpito_calcio_feritoAnimation = [self loadPlistForAnimationWithName:@"colpitoCalcioFeritoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *minacciato_feritoAnimation = [self loadPlistForAnimationWithName:@"minacciatoFeritoAnimation" andClassName:NSStringFromClass([self class])];
    
    //
    
    fermoFrameArray = [[NSArray alloc] initWithObjects: fermoFrame, fermo_feritaFrame, nil];
    camminaAnimationArray = [[NSArray alloc] initWithObjects: camminaAnimation, cammina_feritoAnimation, nil];
    indietreggiaAnimationArray = [[NSArray alloc] initWithObjects: indietreggiaAnimation, indietreggia_feritoAnimation, nil];
    pre_colpitoAnimationArray = [[NSArray alloc] initWithObjects: pre_colpitoAnimation, pre_colpito_feritoAnimation, nil];
    colpito_pugnoAnimationArray = [[NSArray alloc] initWithObjects: colpito_pugnoAnimation, colpito_pugno_feritoAnimation, nil];
    colpito_calcioAnimationArray = [[NSArray alloc] initWithObjects: colpito_calcioAnimation, colpito_calcio_feritoAnimation, nil];
    minacciatoAnimationArray = [[NSArray alloc] initWithObjects: minacciatoAnimation, minacciato_feritoAnimation, nil];
    
    indiceAnimazione = 0;
}


- (void) dealloc {
    
    [fermoFrameArray release];
    [camminaAnimationArray release];
    [indietreggiaAnimationArray release];
    [pre_colpitoAnimationArray release];
    [colpito_pugnoAnimationArray release];
    [colpito_calcioAnimationArray release];
    [minacciatoAnimationArray release];
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        self.gameObjectType = kCameramanType;
        self.characterHealth = 100;
        
        [self initAnimations];
    }
    return self;
}

@end
