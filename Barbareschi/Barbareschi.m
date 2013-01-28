//
//  Barbareschi.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Barbareschi.h"


@implementation Barbareschi

@synthesize camminaAnimation, attaccaPugnoAnimation, attaccaCalcioAnimation, esultaAnimation;
@synthesize joystick, attackButton;

-(int)getWeaponDamage {
    
    //Verso destra sta danneggiando la iena. Verso sinistra il cameraman.
    if (self.flipX) {
        return kBarbareschiIenaDamage;
    }
    return kBarbareschiCameramanDamage;
}

-(void)applyJoystick:(SneakyJoystick *)aJoystick forTimeDelta:(float)deltaTime {
    
    double constVelocity = 0.5;
    if (aJoystick.velocity.x < 0){
        constVelocity = -constVelocity;
    }
    
    double scaledVelocityX = constVelocity * 480.0f;

    CGPoint oldPosition = [self position];
    //Muovo solo lungo x
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocityX * deltaTime,
                              oldPosition.y);
    
    [self setPosition:newPosition];
    
    //Verso destra, flipX è YES.
    if (oldPosition.x > newPosition.x) {
        self.flipX = YES;
    } else {
        self.flipX = NO;
    }
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
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: esultaAnimation restoreOriginalFrame:NO]];
            break;
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    if (self.characterState == kStateEsulta)
        return; // Nothing to do.
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    
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
    
    [self checkAndClampSpritePosition];
    
    double sogliaJoystick = 0.9;
    
    if ((self.characterState == kStateFermo) || (self.characterState == kStateCammina)) {
        
        if (attackButton.active) {
            
            ///Gestisco anche lo stato precedente in modo da prendere un solo click.
            BOOL isClicked = self.prevCharacterState != kStateAttacco_pugno || self.prevCharacterState != kStateAttacco_calcio;
            
            if (isClicked) {
                CCLOG(@"attackButton was pressed");
                
                if (attaccaConPugno)
                    [self changeState: kStateAttacco_pugno];
                else
                    [self changeState: kStateAttacco_calcio];
                
                attaccaConPugno = !attaccaConPugno;
            }
            
        } else if (fabs(joystick.velocity.x) >= sogliaJoystick) { // dpad moving
            
            if (self.characterState != kStateCammina)
                [self changeState:kStateCammina];
            
            [self applyJoystick:joystick forTimeDelta:deltaTime];
        
        } else {
            [self changeState: kStateFermo];
        }
        
    } else if (self.characterState == kStateAttacco_pugno || self.characterState == kStateAttacco_calcio) {
        
        if ([self numberOfRunningActions] == 0)
            [self changeState: kStateFermo];
    }
    
    /*
    if ([self numberOfRunningActions] == 0) {
        // Not playing an animation
        if (self.characterHealth <= 0.0f) {
            [self changeState: kStateEsulta];
        }
    }
     */
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
    
    if (characterState == kStateCammina) {
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
    }
    return self;
}

@end
