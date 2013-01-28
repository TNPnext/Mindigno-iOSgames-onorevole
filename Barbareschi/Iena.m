//
//  Iena.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Iena.h"


@implementation Iena

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
    
    CCSpriteFrame *fermoFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kIena_fermoFrameName];
    CCSpriteFrame *fermo_feritaFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kIena_fermo_feritaFrameName];
    
    CCAnimation *camminaAnimation = [self loadPlistForAnimationWithName:@"camminaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *indietreggiaAnimation = [self loadPlistForAnimationWithName:@"indietreggiaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *pre_colpitaAnimation = [self loadPlistForAnimationWithName:@"preColpitaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpita_pugnoAnimation = [self loadPlistForAnimationWithName:@"colpitaPugnoAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpita_calcioAnimation = [self loadPlistForAnimationWithName:@"colpitaCalcioAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *minacciataAnimation = [self loadPlistForAnimationWithName:@"minacciataAnimation" andClassName:NSStringFromClass([self class])];
    
    CCAnimation *cammina_feritaAnimation = [self loadPlistForAnimationWithName:@"camminaFeritaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *indietreggia_feritaAnimation = [self loadPlistForAnimationWithName:@"indietreggiaFeritaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *pre_colpita_feritaAnimation = [self loadPlistForAnimationWithName:@"preColpitaFeritaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpita_pugno_feritaAnimation = [self loadPlistForAnimationWithName:@"colpitaPugnoFeritaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *colpita_calcio_feritaAnimation = [self loadPlistForAnimationWithName:@"colpitaCalcioFeritaAnimation" andClassName:NSStringFromClass([self class])];
    CCAnimation *minacciata_feritaAnimation = [self loadPlistForAnimationWithName:@"minacciataFeritaAnimation" andClassName:NSStringFromClass([self class])];
    
    //

    fermoFrameArray = [[NSArray alloc] initWithObjects: fermoFrame, fermo_feritaFrame, nil];
    camminaAnimationArray = [[NSArray alloc] initWithObjects: camminaAnimation, cammina_feritaAnimation, nil];
    indietreggiaAnimationArray = [[NSArray alloc] initWithObjects: indietreggiaAnimation, indietreggia_feritaAnimation, nil];
    pre_colpitaAnimationArray = [[NSArray alloc] initWithObjects: pre_colpitaAnimation, pre_colpita_feritaAnimation, nil];
    colpita_pugnoAnimationArray = [[NSArray alloc] initWithObjects: colpita_pugnoAnimation, colpita_pugno_feritaAnimation, nil];
    colpita_calcioAnimationArray = [[NSArray alloc] initWithObjects: colpita_calcioAnimation, colpita_calcio_feritaAnimation, nil];
    minacciataAnimationArray = [[NSArray alloc] initWithObjects: minacciataAnimation, minacciata_feritaAnimation, nil];
    
    indiceAnimazione = 0;
}


- (void) dealloc {
    
    [fermoFrameArray release];
    [camminaAnimationArray release];
    [indietreggiaAnimationArray release];
    [pre_colpitaAnimationArray release];
    [colpita_pugnoAnimationArray release];
    [colpita_calcioAnimationArray release];
    [minacciataAnimationArray release];
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        self.gameObjectType = kIenaType;
        self.characterHealth = 100;
        
        [self initAnimations];
    }
    return self;
}

@end
