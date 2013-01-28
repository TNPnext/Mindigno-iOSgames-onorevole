//  CommonProtocols.h

typedef enum {
    kStateFermo,
    kStateCammina,
    kStateAttacco_pugno,
    kStateAttacco_calcio,
    kStateEsulta
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kBarbareschiType,
    kIenaType,
    kCameramanType,
    kNuvolaType
} GameObjectType;