//
//  Barbareschi.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Barbareschi.h"


@implementation Barbareschi

@synthesize walkingAnimation, attackPugnoAnimation, attackCalcioAnimation;
@synthesize joystick, attackButton;

/*
-(int)getWeaponDamage {
    if (isCarryingMallet) {
        return kVikingMalletDamage;
    }
    return kVikingFistDamage;
}
 */

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
            
        case kStateIdle:
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"barba_10.png"]];
            break;
            
        case kStateAttacking:
            
            if (attackWithPugno)
                action = [CCAnimate actionWithAnimation: attackPugnoAnimation restoreOriginalFrame:NO];
            else
                action = [CCAnimate actionWithAnimation: attackCalcioAnimation restoreOriginalFrame:NO];
            
            attackWithPugno = !attackWithPugno;
            
            break;
            
        case kStateWalking:
            action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: walkingAnimation restoreOriginalFrame:NO]];
            break;
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    
    if (self.characterState == kStateDead)
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
    
    if ((self.characterState == kStateIdle) || (self.characterState == kStateWalking)) {
        
        if (attackButton.active) {
            
            ///Gestisco anche lo stato precedente in modo da prendere un solo click.
            BOOL isClicked = self.prevCharacterState != kStateAttacking;
            
            if (isClicked) {
                CCLOG(@"attackButton was pressed");
            }
            
            [self changeState:kStateAttacking];
            
        } else if (fabs(joystick.velocity.x) >= sogliaJoystick) { // dpad moving
            
            if (self.characterState != kStateWalking)
                [self changeState:kStateWalking];
            
            [self applyJoystick:joystick forTimeDelta:deltaTime];
        
        } else {
            [self changeState: kStateIdle];
        }
        
    } else if (self.characterState == kStateAttacking) {
        
        if ([self numberOfRunningActions] == 0)
            [self changeState: kStateIdle];
    }
    
    if ([self numberOfRunningActions] == 0) {
        // Not playing an animation
        if (self.characterHealth <= 0.0f) {
            [self changeState:kStateDead];
        }
    }
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
    
    if (characterState == kStateWalking) {
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
    
    [self setWalkingAnimation:[self loadPlistForAnimationWithName:@"walkingAnimation" andClassName:NSStringFromClass([self class])]];
    
    [self setAttackPugnoAnimation:[self loadPlistForAnimationWithName:@"attackPugnoAnimation" andClassName:NSStringFromClass([self class])]];
    
    [self setAttackCalcioAnimation:[self loadPlistForAnimationWithName:@"attackCalcioAnimation" andClassName:NSStringFromClass([self class])]];
}


- (void) dealloc {
    
    joystick = nil;
    attackButton = nil;
    
    [walkingAnimation release];
    [attackPugnoAnimation release];
    [attackCalcioAnimation release];
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        joystick = nil;
        attackButton = nil;
        //
        
        self.gameObjectType = kBarbareschiType;
        
        attackWithPugno = YES;
        self.prevCharacterState = kStateIdle;
        self.characterState = kStateIdle;
      
        [self initAnimations];
    }
    return self;
}

@end
