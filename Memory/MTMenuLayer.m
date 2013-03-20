//
//  MTMenuLayer.m
//  Memory
//
//  Created by Jake Scott on 20/03/13.
//
//

#import "MTMenuLayer.h"
#import "MTPlayfieldScene.h"

@implementation MTMenuLayer

-(id) init
{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Create the title as a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Memory Game" fontName:@"Marker Felt" fontSize:64];
        [label setColor:ccBLUE];
        label.position = ccp(winSize.width / 2, winSize.height/2 + 50);
        [self addChild:label];
        
        // Create Label Menu Items for the 3 game levels
        CCLabelTTF *startGameEasyLbl = [CCLabelTTF labelWithString:@"Start Game - Easy" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameEasyItem = [CCMenuItemLabel itemWithLabel:startGameEasyLbl target:self selector:@selector(startGameEasy)];
        
        CCLabelTTF *startGameMediumLbl = [CCLabelTTF labelWithString:@"Start Game - Medium" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameMediumItem = [CCMenuItemLabel itemWithLabel:startGameMediumLbl target:self selector:@selector(startGameMedium)];
        
        CCLabelTTF *startGameHardLbl = [CCLabelTTF labelWithString:@"Start Game - Hard" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *startGameHardItem = [CCMenuItemLabel itemWithLabel:startGameHardLbl target:self selector:@selector(startGameHard)];
        
        // Create the menu
        CCMenu *startMenu = [CCMenu menuWithItems:startGameEasyItem, startGameMediumItem, startGameHardItem, nil];
        [startMenu alignItemsVerticallyWithPadding:15];
        [startMenu setPosition:ccp(winSize.width/2, winSize.height/4)];
        [self addChild:startMenu];
    }
    
    return self;
}

-(void) startGameEasy
{
    [[CCDirector sharedDirector] replaceScene:[MTPlayfieldScene sceneWithRows:2 andColumns:2]];
}

-(void) startGameMedium
{
    [[CCDirector sharedDirector] replaceScene:[MTPlayfieldScene sceneWithRows:2 andColumns:2]];
}

-(void) startGameHard
{
    [[CCDirector sharedDirector] replaceScene:[MTPlayfieldScene sceneWithRows:2 andColumns:2]];
}

@end
