//
//  Gameplay.m
//  GameArchitecture
//
//  Created by Dion Larson on 2/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "WinPopup.h"
#import "CCActionFollow+CurrentOffset.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Level.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";
static int levelSpeed = 0;

@implementation Gameplay {
  CCSprite *_character;
  CCPhysicsNode *_physicsNode;
  CCNode *_levelNode;
  Level *_loadedLevel;
  CCLabelTTF *_scoreLabel;
  BOOL _jumped;
  
  int _score;
}

#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
  _physicsNode.collisionDelegate = self;
  _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
  [_levelNode addChild:_loadedLevel];
  
  levelSpeed = _loadedLevel.levelSpeed;
}

- (void)onEnter {
  [super onEnter];
  
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_character worldBoundary:[_loadedLevel boundingBox]];
  _physicsNode.position = [follow currentOffset];
  [_physicsNode runAction:follow];
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  
  self.userInteractionEnabled = YES;
}

#pragma mark - Level completion

- (void)loadNextLevel {
  selectedLevel = _loadedLevel.nextLevelName;
  
  CCScene *nextScene = nil;
  
  if (selectedLevel) {
    nextScene = [CCBReader loadAsScene:@"Gameplay"];
  } else {
    selectedLevel = kFirstLevel;
    nextScene = [CCBReader loadAsScene:@"StartScene"];
  }
  
  CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
  [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [_character.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
    if (!_jumped) {
      [_character.physicsBody applyImpulse:ccp(0, 1000)];
      _jumped = TRUE;
      [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
    }
  }];
}

#pragma mark - Player Movement

- (void)resetJump {
  _jumped = FALSE;
}

- (void)fixedUpdate:(CCTime)delta
{
  _character.physicsBody.velocity = ccp(40.f, _character.physicsBody.velocity.y);
}

#pragma mark - Collision Handling
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero flag:(CCNode *)flag {
  self.paused = YES;
  
  WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
  popup.positionType = CCPositionTypeNormalized;
  popup.position = ccp(0.5, 0.5);
  [self addChild:popup];
  
  return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero star:(CCNode *)star {
  [star removeFromParent];
  _score++;
  _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
  
  return NO;
}

#pragma mark - Update

- (void)update:(CCTime)delta {
  if (CGRectGetMaxY([_character boundingBox]) <   CGRectGetMinY([_loadedLevel boundingBox])) {
    [self gameOver];
  }
}

#pragma mark - Game Over

- (void)gameOver {
  CCScene *restartScene = [CCBReader loadAsScene:@"Gameplay"];
  CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
  [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}

@end
