//  GameCharacter.h
//  SpaceViking

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
    
    int characterHealth;
    
    CharacterStates prevCharacterState;
    CharacterStates characterState;
}

-(BOOL)checkAndClampSpritePosition;
-(int)getWeaponDamage;

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates prevCharacterState;
@property (readwrite) CharacterStates characterState;

@end
