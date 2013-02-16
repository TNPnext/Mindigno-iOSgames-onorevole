//  Constants.h
// Constants used

#define kBackgroundSpriteZValue 0
#define kNuvoleSpriteZValue 10
#define kGameplaySpriteBatchNodeZValue 25
#define kBarbareschiSpriteZValue 50
#define kFinalGameSpriteZValue 80
#define kPointsSpriteZValue 85
#define kHeaderSpriteZValue 90
#define kControlSpriteZValue 100


#define kBarbareschiSpriteTagValue 0
#define kIenaSpriteTagValue 1
#define kCameramanSpriteTagValue 2
#define kNuvolaSpriteTagValue 3
#define kLifebarIenaSpriteTagValue 4
#define kLifebarCameramanSpriteTagValue 5
#define kPointsLabelSpriteTagValue 6


#define kBarbareschiIenaDamage 30
#define kBarbareschiCameramanDamage 40


typedef enum {
    
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kVideoScene=2,
    kGameLevel1=101
    
} SceneTypes;

typedef enum {
    
    kLinkTypeMindignoSite,
    kLinkTypeDeveloperSite
    
} LinkTypes;


// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum {
    
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]
