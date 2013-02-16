//
//  Cameraman.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Cameraman.h"
#import "Lifebar.h"
#import "GameManager.h"
#import "PointTable.h"

@implementation Cameraman

- (void)spostatiVersoSx:(BOOL)yOrNot barbareschi:(GameObject*)barbareschi conTempo:(ccTime)deltaTime {
    
    double constVelocity = originalConstVelocity;
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
            animation = [minacciatoAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStatePre_colpito:
            animation = [pre_colpitoAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO]];
            break;
            
        case kStateAttaccato_conPugno:
            PLAYSOUNDEFFECT(CAZZOTTO);
            animation = [colpito_pugnoAnimationArray objectAtIndex: indiceAnimazione];
            action = [CCAnimate actionWithAnimation: animation restoreOriginalFrame:NO];
            break;
            
        case kStateAttaccato_conCalcio:
            PLAYSOUNDEFFECT(CAZZOTTO);
            animation = [colpito_calcioAnimationArray objectAtIndex: indiceAnimazione];
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

-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
    if (self.characterState == kStateMorto)
        return;
    
    GameCharacter *barbareschi = (GameCharacter*)[[self parent] getChildByTag: kBarbareschiSpriteTagValue];
    CharacterStates barbareschiState = barbareschi.characterState;
    
    Lifebar *lifebar = (Lifebar*)[[[self parent] parent] getChildByTag: kLifebarCameramanSpriteTagValue];
    PointTable *pointTable = (PointTable*)[[[self parent] parent] getChildByTag: kPointsLabelSpriteTagValue];
    
    if (barbareschiState == kStateEsulta)
        return; // Nothing to do.
    
    CGRect myBox = [self adjustedBoundingBox];
    CGRect characterBox = [barbareschi adjustedBoundingBox];
    
    BOOL versoSinistra = [barbareschi flipX];
    if (barbareschiState == kStateCammina && !versoSinistra) {
        
        [self spostatiVersoSx:NO barbareschi:barbareschi conTempo:deltaTime];
        
        if (self.characterState != kStateCammina)
            [self changeState:kStateCammina];
        
    } else if (barbareschiState == kStateCammina && versoSinistra) {
        
        [self spostatiVersoSx:YES barbareschi:barbareschi conTempo:deltaTime];
        
        if (self.characterState != kStateIndietreggia)
            [self changeState:kStateIndietreggia];
        
    } else if (barbareschiState == kStateFermo && !versoSinistra) {
        
        if (self.characterState != kStateFermo)
            [self changeState: kStateFermo];
        
    } else if (barbareschiState == kStateFermo && versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateIndietreggia) {
            
            if ([self numberOfRunningActions] == 0 || self.characterState == kStateMinacciato)
                [self changeState: kStatePre_colpito];
            
        } else {
            [self changeState: kStateMinacciato];
        }
        
    } else if (barbareschiState == kStateAttacco_pugno && versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateAttaccato_conPugno) {
            [self changeState: kStateAttaccato_conPugno];
            
            self.characterHealth -= [barbareschi getWeaponDamage];
            [lifebar setLife: self.characterHealth];
            
            int currentPoints = [[GameManager sharedGameManager] addPoints];
            [pointTable setStringWithAnimation: [NSString stringWithFormat:@"%d", currentPoints]];
        }
        
    } else if (barbareschiState == kStateAttacco_calcio && versoSinistra) {
        
        //Se collide
        if (CGRectIntersectsRect(myBox, characterBox) && self.characterState != kStateAttaccato_conCalcio) {
            [self changeState: kStateAttaccato_conCalcio];
            
            self.characterHealth -= [barbareschi getWeaponDamage];
            [lifebar setLife: self.characterHealth];
            
            int currentPoints = [[GameManager sharedGameManager] addPoints];
            [pointTable setStringWithAnimation: [NSString stringWithFormat:@"%d", currentPoints]];
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
    
    float xCropAmount = boundingBox.size.width * 0.05f;
    float yCropAmount = boundingBox.size.height * 0.0f;
    
    if (self.characterState != kStateCammina &&
        self.characterState != kStateFermo) {
        
        xOffset = boundingBox.size.width * -0.35f;
    }
    
    boundingBox = CGRectMake(boundingBox.origin.x + xOffset,
                             boundingBox.origin.y,
                             boundingBox.size.width - xCropAmount,
                             boundingBox.size.height - yCropAmount);
    
    if ([[CCDirector sharedDirector] enableRetinaDisplay: YES]) {
        boundingBox = CGRectMake(boundingBox.origin.x * 2, boundingBox.origin.y * 2, boundingBox.size.width * 2, boundingBox.size.height * 2);
    }
    
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
    
        [self initAnimations];
        
        originalConstVelocity = -0.52;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            originalConstVelocity = originalConstVelocity * 2;
        }
    }
    return self;
}

@end
