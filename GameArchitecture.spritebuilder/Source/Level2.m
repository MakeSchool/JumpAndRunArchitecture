//
//  Level2.m
//  GameArchitecture
//
//  Created by Benjamin Encz on 10/06/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level2.h"
#import "WinPopup.h"
#import "CCActionFollow+CurrentOffset.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Level2 {
  CCSprite *_character;
  CCPhysicsNode *_physicsNode;
  BOOL _jumped;
}

- (void)didLoadFromCCB {
  _physicsNode.collisionDelegate = self;
}

- (void)onEnter {
  [super onEnter];
  
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_character worldBoundary:_physicsNode.boundingBox];
  _physicsNode.position = [follow currentOffset];
  [_physicsNode runAction:follow];
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  
  self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [_character.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
    if (!_jumped) {
      [_character.physicsBody applyImpulse:ccp(0, 2000)];
      _jumped = TRUE;
      [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
    }
  }];
}

- (void)resetJump {
  _jumped = FALSE;
}

- (void)fixedUpdate:(CCTime)delta
{
  _character.physicsBody.velocity = ccp(40.f, _character.physicsBody.velocity.y);
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero flag:(CCNode *)flag {
  self.paused = YES;
  
  WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup"];
  popup.positionType = CCPositionTypeNormalized;
  popup.position = ccp(0.5, 0.5);
  popup.nextLevelName = @"Level3";
  [self addChild:popup];
  
  return TRUE;
}

- (void)update:(CCTime)delta {
  if (CGRectGetMaxY([_character boundingBox]) <  CGRectGetMinY(_physicsNode.boundingBox)) {
    [self gameOver];
  }
}

- (void)gameOver {
  CCScene *restartScene = [CCBReader loadAsScene:@"Level2"];
  CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
  [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}

@end

