//  CommonProtocols.h

typedef enum {
    
    kStateFermo,
    kStateCammina,
    kStateAttacco_pugno,
    kStateAttacco_calcio,
    kStateEsulta,
    
    kStateIndietreggia,
    kStateMinacciato,
    kStatePre_colpito,
    kStateAttaccato_conPugno,
    kStateAttaccato_conCalcio,
    
    kStateGoLeft,
    kStateGoRight
    
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kBarbareschiType,
    kIenaType,
    kCameramanType,
    kNuvolaType
} GameObjectType;