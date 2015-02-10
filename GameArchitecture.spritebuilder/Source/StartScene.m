//
//  StartScene.m
//  GameArchitecture
//
//  Created by Benjamin Encz on 10/06/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"

@implementation StartScene

- (void)startGame {
  CCScene *firstLevel = [CCBReader loadAsScene:@"Gameplay"];
  CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
  [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
