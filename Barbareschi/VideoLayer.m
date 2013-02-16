//
//  VideoLayer.m
//  Barbareschi
//
//  Created by Enrico on 14/02/13.
//
//

#import "VideoLayer.h"

@implementation VideoLayer

+ (id)scene {

    return [VideoLayer node];
}

- (id) init {
    
    if (self = [super init]) {
        
        [CCVideoPlayer setDelegate: self];
        [CCVideoPlayer playMovieWithFile: @"Barbareschi.m4v"];
    }
    
    return self;
}

- (void) movieStartsPlaying {

    CCLOG(@"start play");
}

- (void) moviePlaybackFinished {

    CCLOG(@"stop play");
    
    [[GameManager sharedGameManager] runSceneWithID: kGameLevel1];
}

@end
