//  GameManager.h
//  SpaceViking
//
#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"

#define APP_URL @"www.mindigno.com"

@interface GameManager : NSObject {
    
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    int points;
    ccTime timeFromPlay;
    
    SceneTypes currentScene;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
    
}
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;
@property (readwrite) int points;
@property (readonly) ccTime timeFromPlay;
@property (readwrite) GameManagerSoundState managerSoundState;
//@property (readonly) SimpleAudioEngine *soundEngine;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen ;
-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;

//Aggiunge punti in base a suoi criteri e restituisce il punteggio corrente.
- (int) addPoints;
- (void) sumTime:(ccTime)delta;

@end
