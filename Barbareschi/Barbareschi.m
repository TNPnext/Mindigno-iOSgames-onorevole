//
//  Barbareschi.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Barbareschi.h"
#import "GameManager.h"
#import "GameOverLayer.h"

@implementation Barbareschi

@synthesize camminaAnimation, attaccaPugnoAnimation, attaccaCalcioAnimation, esultaAnimation;
@synthesize joystick, attackButton;

-(int)getWeaponDamage {
    
    //Verso destra sta danneggiando la iena. Verso sinistra il cameraman.
    if (!self.flipX) {
        return kBarbareschiIenaDamage;
    }
    return kBarbareschiCameramanDamage;
}

-(void)applyJoystick:(SneakyJoystick *)aJoystick forTimeDelta:(float)deltaTime character:(GameObject*)character {
    
    double constVelocity = originalConstVelocity;
    if (aJoystick.velocity.x < 0){
        constVelocity = -constVelocity;
    }
    
    double scaledVelocityX = constVelocity * 480.0f;

    CGPoint oldPosition = [self position];
    //Muovo solo lungo x
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocityX * deltaTime,
                              oldPosition.y);
    
    CGRect myBox = [self adjustedBoundingBox];
    CGRect characterBox = [character adjustedBoundingBox];
    
    //Se non c'è collisione imposto la nuova posizione. Altrimenti lascio quella attuale.
    if (!CGRectIntersectsRect(myBox, characterBox)) {
        [self setPosition: newPosition];
    }
    
    //Verso destra, flipX è NO.
    if (oldPosition.x >= newPosition.x) {
        self.flipX = YES;
    } else {
        self.flipX = NO;
    }
}

-(void)playLastSound {
    PLAYSOUNDEFFECT(FREGATO_IL_CELLULARE);
}

-(void)changeState:(CharacterStates)newState {
    
    [self stopAllActions];
    id action = nil;
    
    CharacterStates oldState = [self characterState];
    [self setPrevCharacterState: oldState];
    [self setCharacterState: newState];
    
    switch (newState) {
            
        case kStateFermo:
            [self setDisplayFrame: fermoFrame];
            break;
            
        case kStateAttacco_pugno:
            action = [CCAnimate actionWithAnimation: attaccaPugnoAnimation restoreOriginalFrame:NO];
            
            break;
            
        case kStateAttacco_calcio:
            action = [CCAnimate actionWithAnimation: attaccaCalcioAnimation restoreOriginalFrame:NO];
        
            break;
            
        case kStateCammina:
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: camminaAnimation restoreOriginalFrame:NO]];
            break;
            
        case kStateEsulta:
            [[GameManager sharedGameManager] setHasPlayerDied:YES];
            
            PLAYSOUNDEFFECT(FINE);
            
            [self runAction: [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: esultaAnimation restoreOriginalFrame:NO]]];
             
            action = [CCSequence actions:
                      [CCDelayTime actionWithDuration:2],
                      [CCCallFunc actionWithTarget:self selector:@selector(playLastSound)],
                      nil];
            
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
        case 2:
            PLAYSOUNDEFFECT(CRETINO);
            break;
            
        case 6:
            PLAYSOUNDEFFECT(CRETINO_2);
            break;
            
        case 10:
            PLAYSOUNDEFFECT(IMBECILLE);
            break;
            
        case 14:
            PLAYSOUNDEFFECT(IMBECILLE_2);
            break;
            
        case 18:
            PLAYSOUNDEFFECT(FASCISTELLO);
            break;
            
        case 22:
            PLAYSOUNDEFFECT(TEPPISTELLO);
            break;
            
        case 26:
            PLAYSOUNDEFFECT(VERGOGNA);
            break;
            
        default:
            break;
    }
    
    indiceSoundToPlay++;
    if (indiceSoundToPlay > 27) {
        indiceSoundToPlay = 0;
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime {
    
    if (self.characterState == kStateEsulta)
        return; // Nothing to do.
    
    GameCharacter *iena = (GameCharacter*)[[self parent] getChildByTag: kIenaSpriteTagValue];
    GameCharacter *cameraman = (GameCharacter*)[[self parent] getChildByTag: kCameramanSpriteTagValue];
    
    //Non serve perchè fanno da limite la iena e il cameraman
    //[self checkAndClampSpritePosition];
    
    if ((self.characterState == kStateFermo) || (self.characterState == kStateCammina)) {
        
        if (attackButton.active) {
            
            ///Gestisco anche lo stato precedente in modo da prendere un solo click.
            BOOL isClicked = self.prevCharacterState != kStateAttacco_pugno || self.prevCharacterState != kStateAttacco_calcio;
            
            if (isClicked) {
                //CCLOG(@"attackButton was pressed");
                
                [self playNextSound];
                
                if (attaccaConPugno)
                    [self changeState: kStateAttacco_pugno];
                else
                    [self changeState: kStateAttacco_calcio];
                
                attaccaConPugno = !attaccaConPugno;
            }
            
        } else if (fabs(joystick.velocity.x) > 0) {
            
            if (self.characterState != kStateCammina)
                [self changeState:kStateCammina];
            
            if (![self flipX]) {
                [self applyJoystick:joystick forTimeDelta:deltaTime character:iena];
            } else {
                [self applyJoystick:joystick forTimeDelta:deltaTime character:cameraman];
            }
        
        } else {
            [self changeState: kStateFermo];
        }
        
    } else if (self.characterState == kStateAttacco_pugno || self.characterState == kStateAttacco_calcio) {
        
        if ([self numberOfRunningActions] == 0)
            [self changeState: kStateFermo];
    }
    
    //Gioco finito
    if ([self numberOfRunningActions] == 0) {
        if ([iena characterHealth] <= 0.0f && [cameraman characterHealth] <= 0.0f) {
            [self changeState: kStateEsulta];
            
            CCLOG(@"Fine partita a: %f sec.", [[GameManager sharedGameManager] timeFromPlay]);
        }
    }
    
    [self checkAndClampSpritePosition];
}

-(CGRect)adjustedBoundingBox {
    
    // Adjust the bouding box to the size of the sprite
    // without the transparent space
    CGRect boundingBox = [super boundingBox];
    
    float xOffset;
    
    if (![self flipX]) {
        // Is facing to the rigth
        xOffset = boundingBox.size.width * 0.16f;
    } else {
        // Is facing to the left
        xOffset = boundingBox.size.width * 0.24f;
    }
    
    float xCropAmount = boundingBox.size.width * 0.40f;
    float yCropAmount = boundingBox.size.height * 0.0f;
    
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
    
    fermoFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: kBarbareschi_fermoFrameName];
    
    [self setCamminaAnimation: [self loadPlistForAnimationWithName:@"camminaAnimation" andClassName:NSStringFromClass([self class])]];
    [self setAttaccaPugnoAnimation: [self loadPlistForAnimationWithName:@"attaccaPugnoAnimation" andClassName:NSStringFromClass([self class])]];
    [self setAttaccaCalcioAnimation: [self loadPlistForAnimationWithName:@"attaccaCalcioAnimation" andClassName:NSStringFromClass([self class])]];
    [self setEsultaAnimation: [self loadPlistForAnimationWithName:@"esultaAnimation" andClassName:NSStringFromClass([self class])]];
}


- (void) dealloc {
    
    joystick = nil;
    attackButton = nil;
    
    //
    
    [camminaAnimation release];
    [attaccaPugnoAnimation release];
    [attaccaCalcioAnimation release];
    [esultaAnimation release];
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        joystick = nil;
        attackButton = nil;
        //
        
        self.gameObjectType = kBarbareschiType;
        
        attaccaConPugno = YES;
        self.prevCharacterState = kStateFermo;
        self.characterState = kStateFermo;
      
        [self initAnimations];
        
        indiceSoundToPlay = 0;
        
        [self setFlipX: YES];
        
        originalConstVelocity = 0.5;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            originalConstVelocity = originalConstVelocity * 2;
        }
    }
    return self;
}

@end
