//
//  Level1.m
//  GameArchitecture
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "WinPopup.h"
#import "CCActionFollow+CurrentOffset.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Level.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";

@implementation Gameplay {
  CCSprite *_character;
  CCPhysicsNode *_physicsNode;
  CCNode *_levelNode;
  Level *_loadedLevel;
  CCNode *_startPosition;
  BOOL _jumped;
}

#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
  _physicsNode.collisionDelegate = self;
  _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
  _character.position = _startPosition.position;
  [_levelNode addChild:_loadedLevel];
}

- (void)onEnter {
  [super onEnter];

  _character.physicsBody.body.body->velocity_func = playerUpdateVelocity;
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_character worldBoundary:[_levelNode.children[0] boundingBox]];
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
      [_character.physicsBody applyImpulse:ccp(0, 2000)];
      _jumped = TRUE;
      [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
    }
  }];
}

#pragma mark - Player Movement

- (void)resetJump {
  _jumped = FALSE;
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
  cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
  
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
  
	// Reset forces.
	body->f = cpvzero;
	body->t = 0.0f;
  
	body->v.x = 40.f;
}

#pragma mark - Collision Handling

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero flag:(CCNode *)flag {
  self.paused = YES;
  
  WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
  popup.positionType = CCPositionTypeNormalized;
  popup.position = ccp(0.5, 0.5);
  [self addChild:popup];
  
  return TRUE;
}

@end
