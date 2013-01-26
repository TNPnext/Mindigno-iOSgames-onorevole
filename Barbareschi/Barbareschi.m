//
//  Barbareschi.m
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Barbareschi.h"


@implementation Barbareschi

@synthesize walkingAnimation;
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
    
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 480.0f);
    
    CGPoint oldPosition = [self position];
    //Muovo solo lungo x
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocity.x * deltaTime,
                              oldPosition.y);
    
    [self setPosition:newPosition];
    
    if (oldPosition.x > newPosition.x) {
        self.flipX = YES;
    } else {
        self.flipX = NO;
    }
    
    //
    
    //Gestisco anche lo stato precedente in modo da prendere un solo click e non due o tre.
    BOOL isAttackButtonActive = attackButton.active;
    BOOL isClicked = isAttackButtonActive && !prevAttackButtonActive;
    
    if (isClicked) {
        CCLOG(@"attackButton was pressed");
    }
    
    prevAttackButtonActive = isAttackButtonActive;
}

/*
-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    id movementAction = nil;
    CGPoint newPosition;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateIdle:
            if (isCarryingMallet) {
                [self setDisplayFrame:[[CCSpriteFrameCache
                                        sharedSpriteFrameCache]
                                       spriteFrameByName:@"sv_mallet_1.png"]];
            } else {
                [self setDisplayFrame:[[CCSpriteFrameCache
                                        sharedSpriteFrameCache]
                                       spriteFrameByName:@"sv_anim_1.png"]];
            }
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    if (self.characterState == kStateDead)
        return; // Nothing to do if the Viking is dead
    
    if ((self.characterState == kStateTakingDamage) &&
        ([self numberOfRunningActions] > 0))
        return; // Currently playing the taking damage animation
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameCharacter *character in listOfGameObjects) {
        // This is Ole the Viking himself
        // No need to check collision with one's self
        if ([character tag] == kVikingSpriteTagValue)
            continue;
        
        CGRect characterBox = [character adjustedBoundingBox];
        if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
            // Remove the PhaserBullet from the scene
            if ([character gameObjectType] == kEnemyTypePhaser) {
                [self changeState:kStateTakingDamage];
                [character changeState:kStateDead];
            } else if ([character gameObjectType] ==
                       kPowerUpTypeMallet) {
                // Update the frame to indicate Viking is
                // carrying the mallet
                isCarryingMallet = YES;
                [self changeState:kStateIdle];
                // Remove the Mallet from the scene
                [character changeState:kStateDead];
            } else if ([character gameObjectType] ==
                       kPowerUpTypeHealth) {
                [self setCharacterHealth:100.0f];
                // Remove the health power-up from the scene
                [character changeState:kStateDead];
            }
        }
    }
    
    [self checkAndClampSpritePosition];
    if ((self.characterState == kStateIdle) ||
        (self.characterState == kStateWalking) ||
        (self.characterState == kStateCrouching) ||
        (self.characterState == kStateStandingUp) ||
        (self.characterState == kStateBreathing)) {
        
        if (jumpButton.active) {
            [self changeState:kStateJumping];
        } else if (attackButton.active) {
            [self changeState:kStateAttacking];
        } else if ((joystick.velocity.x == 0.0f) &&
                   (joystick.velocity.y == 0.0f)) {
            if (self.characterState == kStateCrouching)
                [self changeState:kStateStandingUp];
        } else if (joystick.velocity.y < -0.45f) {
            if (self.characterState != kStateCrouching)
                [self changeState:kStateCrouching];
        } else if (joystick.velocity.x != 0.0f) { // dpad moving
            if (self.characterState != kStateWalking)
                [self changeState:kStateWalking];
            [self applyJoystick:joystick
                   forTimeDelta:deltaTime];
        }
    }
    
    if ([self numberOfRunningActions] == 0) {
        // Not playing an animation
        if (self.characterHealth <= 0.0f) {
            [self changeState:kStateDead];
        } else if (self.characterState == kStateIdle) {
            millisecondsStayingIdle = millisecondsStayingIdle +
            deltaTime;
            if (millisecondsStayingIdle > kVikingIdleTimer) {
                [self changeState:kStateBreathing];
            }
        } else if ((self.characterState != kStateCrouching) &&
                   (self.characterState != kStateIdle)){
            millisecondsStayingIdle = 0.0f;
            [self changeState:kStateIdle];
        }
    }
}
 */

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {

    [self applyJoystick:joystick forTimeDelta:deltaTime];
}

/*
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
    
    if (characterState == kStateCrouching) {
		// Shrink the bounding box to 56% of height
        // 88 pixels on top on iPad
		vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x,
									   vikingBoundingBox.origin.y,
									   vikingBoundingBox.size.width,
									   vikingBoundingBox.size.height * 0.56f);
	}
    
    return vikingBoundingBox;
}
*/

-(void)initAnimations {
    
    [self setWalkingAnimation:[self loadPlistForAnimationWithName:@"walkingAnimation" andClassName:NSStringFromClass([self class])]];
}


- (void) dealloc {
    
    joystick = nil;
    attackButton = nil;
    
    [walkingAnimation release];
    
    [super dealloc];
}

-(id) init {
    
    self = [super init];
    if(self) {
        
        joystick = nil;
        attackButton = nil;
        prevAttackButtonActive = NO;
        //
        
        self.gameObjectType = kBarbareschiType;
      
        [self initAnimations];
    }
    return self;
}

@end
