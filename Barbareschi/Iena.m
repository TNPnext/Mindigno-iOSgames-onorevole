//
//  Iena.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Iena.h"
#import "Cameraman.h"
#import "Lifebar.h"
#import "GameManager.h"

@implementation Iena

- (void)spostatiVersoSx:(BOOL)yOrNot barbareschi:(GameObject*)barbareschi conTempo:(ccTime)deltaTime {

    double constVelocity = -0.6;
    
    if (!yOrNot) {
        constVelocity = -constVelocity;
    }
    
    double scaledVelocityX = constVelocity * 480.0f;
    
    CGPoint oldPosition = [self position];
    //Muovo solo lungo x
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocityX * deltaTime,
                              oldPosition.y);
    
    CGRect myBox = [self adjustedBoundingBox];
    CGRect characterBox = [barbareschi adjustedBoundingBox];
    
    //Se non c'è collisione imposto la nuova posizione. Altrimenti lascio quella attuale.
    if (!CGRectIntersectsRect(myBox, characterBox)) {
        [self setPosition: newPosition];
    }
}

-(void)changeState:(CharacterStates)newState {
    
    [self stopAllActions];
    
    CCAnimation *animation = nil;
    id action = nil;
    
    CharacterStates oldState = [self characterState];
    [self setPrevCharacterState: oldState];
    [self setCharacterState: newState];
    
    if (self.characterHealth < 50) {
        indiceAnimazione = 1;
    }
    
    switch (newState) {
            
        case kStateFermo:
            [self setDisplayFrame: [fermoFrameArray objectAtIndex: indiceAnimazione]];
            break;
            
        case kStateCammina:
            animation = [camminaAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStateIndietreggia:
            animation = [indietreggiaAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStateMinacciato:
            animation = [minacciataAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStatePre_colpito:
            animation = [pre_colpitaAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStateAttaccato_conPugno:
            PLAYSOUNDEFFECT(CAZZOTTO);
            animation = [colpita_pugnoAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO];
            break;
            
        case kStateAttaccato_conCalcio:
            PLAYSOUNDEFFECT(CAZZOTTO);
            animation = [colpita_calcioAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO];
            break;
            
        case kStateMorto:
            action = [CCMoveTo actionWithDuration:1.0 position:ccp([self position].x, [self position].y-[self adjustedBoundingBox].size.height-100)];
            break;
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)playNextSound {
    
    switch (indiceSoundToPlay) {
        case 0:
            PLAYSOUNDEFFECT(CENTO_PER_CENTO_ASSENZE);
            break;
            
        case 12:
            PLAYSOUNDEFFECT(ASSENTE_AL_PARLAMENTO);
            break;
            
        case 20:
            PLAYSOUNDEFFECT(PERCHE_NON_SI_DIMETTE);
            break;
            
        case 25:
            PLAYSOUNDEFFECT(PERCHE_MENA);
            break;
            
        default:
            break;
    }
    
    indiceSoundToPlay++;
    if (indiceSoundToPlay > 30) {
        indiceSoundToPlay = 0;
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
    if (self.characterState == kStateMorto)
        return;
    
    GameCharacter *barbareschi = (GameCharacter*)[[self parent] getChildByTag: kBarbareschiSpriteTagValue];
    CharacterStates barbareschiState = barbareschi.characterState;
    
    Lifebar *lifebar = (Lifebar*)[[[self parent] parent] getChildByTag: kLifebarIenaSpriteTagValue];
    
    if (barbareschiState == kStateEsulta)
        return; // Nothing to do.
   
    CGRect myBox = [self adjustedBoundingBox];
    CGRect characterBox = [barbareschi adjustedBoundingBox];
    
    BOOL versoSinistra = [barbareschi flipX];    
    if (barbareschiState == kStateCammina && versoSinistra) {
        
        [self spostatiVersoSx:YES barbareschi:barbareschi conTempo:deltaTime];
        
        if (self.characterState != kStateCammina) {
            [self changeState:kStateCammina];
        }
    
    } else if (barbareschiState == kStateCammina && !versoSinistra) {
        
        [self spostatiVersoSx:NO barbareschi:barbareschi conTempo:deltaTime];
        
        if (self.characterState != kStateIndietreggia)
            [self changeState:kStateIndietreggia];
    
    } else if (barbareschiState == kStateFermo && versoSinistra) {
        
        if (self.characterState != kStateFermo)
            [self changeState: kStateFermo];
        
    } else if (barbareschiState == kStateFermo && !versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateIndietreggia) {
            
            if ([self numberOfRunningActions] == 0 || self.characterState == kStateMinacciato)
                [self changeState: kStatePre_colpito];
            
        } else {
            [self changeState: kStateMinacciato];
        }
        
    } else if (barbareschiState == kStateAttacco_pugno && !versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateAttaccato_conPugno) {
            [self changeState: kStateAttaccato_conPugno];
            
            self.characterHealth -= [barbareschi getWeaponDamage];
            [lifebar setLife: self.characterHealth];
            
            [self playNextSound];
        }

    } else if (barbareschiState == kStateAttacco_calcio && !versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateAttaccato_conCalcio) {
            [self changeState: kStateAttaccato_conCalcio];
            
            self.characterHealth -= [barbareschi getWeaponDamage];
            [lifebar setLife: self.characterHealth];
        }
    
    }
    
    //Quando Barbareschi mena con il pugno il cameraman
    GameCharacter *cameraman = (GameCharacter*)[[self parent] getChildByTag: kCameramanSpriteTagValue];
    CharacterStates cameramanState = cameraman.characterState;
    
    if (barbareschiState == kStateAttacco_pugno && versoSinistra && cameramanState != kStateMorto) {
        //Se collide
        if (CGRectIntersectsRect([barbareschi adjustedBoundingBox], [cameraman adjustedBoundingBox]) && cameramanState != kStateAttaccato_conPugno) {
            [self playNextSound];
        }
    }
    
    if (self.characterHealth <= 0) {
        [self changeState: kStateMorto];
    }
    
    [self checkAndClampSpritePosition];
}

-(CGRect)adjustedBoundingBox {
    
    // Adjust the bouding box to the size of the sprite
    // without the transparent space
    CGRect boundingBox = [super boundingBox];
    
    float xOffset = boundingBox.size.width * 0.0f;
    
    float xCropAmount = boundingBox.size.width * 0.0f;
    float yCropAmount = boundingBox.size.height * 0.0f;
    
    if (self.characterState != kStateCammina &&
        self.characterState != kStateFermo) {
        
        xOffset = boundingBox.size.width * 0.30f;
    }
    
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
        
        indiceSoundToPlay = 0;
    }
    return self;
}

@end
