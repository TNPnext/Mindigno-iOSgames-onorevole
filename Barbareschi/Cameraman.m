//
//  Cameraman.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Cameraman.h"


@implementation Cameraman

-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
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

-(CGRect)adjustedBoundingBox {
    
    // Adjust the bouding box to the size of the sprite
    // without the transparent space
    CGRect boundingBox = [super boundingBox];
    
    float xOffset = boundingBox.size.width * 0.0f;
    
    float xCropAmount = boundingBox.size.width * 0.05f;
    float yCropAmount = boundingBox.size.height * 0.0f;
    
    boundingBox = CGRectMake(boundingBox.origin.x + xOffset,
                             boundingBox.origin.y,
                             boundingBox.size.width - xCropAmount,
                             boundingBox.size.height - yCropAmount);
    
    return boundingBox;
}

//Override CCNODE per la visualizzazione dell'adjustedBoundingBox.
- (CGRect) boundingBox {
    
    CGRect ret = [self adjustedBoundingBox];
    return CC_RECT_PIXELS_TO_POINTS( ret );
}
//

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
        
        indiceAnimazione = 0;

        
        [self initAnimations];
    }
    return self;
}

@end
