//  GameCharacter.m
//  SpaceViking

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize characterHealth;
@synthesize prevCharacterState, characterState;

-(void) dealloc { 
    [super dealloc];
}

-(int)getWeaponDamage {
    // Default to zero damage
    CCLOG(@"getWeaponDamage should be overriden");
    return 0;
}

//Ritorna si se è stato sistemato e quindi ha colliso con il bordo dello schermo. No, altrimenti.
-(BOOL) checkAndClampSpritePosition {
    
    BOOL ret = NO;
    
    CGPoint currentSpritePosition = [self position];
    
    CGRect box = [self adjustedBoundingBox];
    
    double divFactor = 2.0;
    if ([[CCDirector sharedDirector] enableRetinaDisplay: YES]) {
        divFactor = 4.0;
    }
    
    double minLimit = (box.size.width/divFactor);
    double maxLimit = screenSize.width-(box.size.width/divFactor);
    
    // Clamp for iPhone, iPhone 4, or iPod touch
    if (currentSpritePosition.x < minLimit) {
        [self setPosition:ccp(minLimit, currentSpritePosition.y)];
        ret = YES;
        
    } else if (currentSpritePosition.x > maxLimit) {
        [self setPosition:ccp(maxLimit, currentSpritePosition.y)];
        ret = YES;
    }
    
    return ret;
}
@end
