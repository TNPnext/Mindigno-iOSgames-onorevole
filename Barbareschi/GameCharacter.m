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

-(void)checkAndClampSpritePosition {
    
    CGPoint currentSpritePosition = [self position];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        // Clamp for the iPad
        if (currentSpritePosition.x < 30.0f) {
            [self setPosition:ccp(30.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 1000.0f) {
            [self setPosition:ccp(1000.0f, currentSpritePosition.y)];
        }
        
    } else {
        
        CGRect box = [self boundingBox];
        double minLimit = (box.size.width/2.0);
        double maxLimit = screenSize.width-(box.size.width/2.0);
        
        // Clamp for iPhone, iPhone 4, or iPod touch
        if (currentSpritePosition.x < minLimit) {
            [self setPosition:ccp(minLimit, currentSpritePosition.y)];
            
        } else if (currentSpritePosition.x > maxLimit) {
            [self setPosition:ccp(maxLimit, currentSpritePosition.y)];
        } 
    }
}
@end
