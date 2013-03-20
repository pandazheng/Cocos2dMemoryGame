//
//  MTPlayfieldLayer.m
//  Memory
//
//  Created by Jake Scott on 20/03/13.
//
//

#import "MTPlayfieldLayer.h"

@implementation MTPlayfieldLayer

+ (id)layerWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols
{
    return [[[self alloc] initWithRows:numRows andColumns:numCols] autorelease];
}

- (id)initWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols
{
    if (self == [super init]) {
        self.isTouchEnabled = YES;

        // Get the window size from the CCDirector
        size = [[CCDirector sharedDirector] winSize];

        // Preload the sound effects
        [self preloadEffects];

        // make sure we've loaded the spritesheets
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"memorysheet.plist"];
        memorySheet = [CCSpriteBatchNode batchNodeWithFile:@"memorysheet.png"];

        // add the batch node to the layer
        [self addChild:memorySheet];

        // Add the back Button to the bottom right corner
        backButton = [CCSprite spriteWithSpriteFrameName:@"backbutton.png"];
        [backButton setAnchorPoint:ccp(1, 0)];
        [backButton setPosition:ccp(size.width - 10, 10)];
        [memorySheet addChild:backButton];

        // Maximum size of the actual playing field
        boardHeight = 400;
        boardWidth = 320;

        // Set the board rows and columns
        boardRows = numRows;
        boardColumns = numCols;

        // If the total number of card positions is not even, remove a row so we don't build an impossible board
        if ((boardRows * boardColumns) % 2) {
            boardRows--;
        }

        maxTiles = (boardRows * boardColumns) / 2;

        padWidth = 10;
        padHeight = 10;

        // Set the desired tile size
        float tileWidth = ((boardWidth - (boardColumns * padWidth)) / boardColumns) - padWidth;
        float tileHeight = (boardHeight - (boardRows * padHeight) / boardRows) - padHeight;

        // Force the tiles to be square
        if (tileWidth > tileHeight) {
            tileWidth = tileHeight;
        } else {
            tileHeight = tileWidth;
        }

        // Store the tileSize so we can use it later
        tileSize = CGSizeMake(tileWidth, tileHeight);

        boardOffsetX = (boardWidth - ((tileSize.width + padWidth) * boardColumns)) / 2;
        boardOffsetY = (boardHeight - ((tileSize.height + padHeight) * boardRows)) / 2;

        // Set the score to zero
        playerScore = 0;

        // will be used for loading and building the playfield
        tilesAvailable = [[NSMutableArray alloc] initWithCapacity:maxTiles];

        // we contain all the tiles that not yet been matched
        tilesInPlay = [[NSMutableArray alloc] initWithCapacity:maxTiles];

        // we be used for the match detection methods
        tilesSelected = [[NSMutableArray alloc] initWithCapacity:2];

        [self acquireMemoryTiles];
        [self generateTileGrid];
        [self calculateLivesRemaining];
        [self generateScoreAndLivesDisplay];
    }

    return self;
}

- (void)generateScoreAndLivesDisplay
{
    // Build the word "SCORE"
    CCLabelTTF *scoreTitle = [CCLabelTTF labelWithString:@"SCORE" fontName:@"Marker Felt" fontSize:30];
    [scoreTitle setPosition:ccpAdd([self scorePosition], ccp(0, 30))];
    [self addChild:scoreTitle];

    // Build the display for the score counter
    playerScoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", playerScore] fontName:@"Marker Felt" fontSize:40];
    [playerScoreDisplay setPosition:[self scorePosition]];
    [self addChild:playerScoreDisplay];

    // Build the word "LIVES"
    CCLabelTTF *livesTitle = [CCLabelTTF labelWithString:@"LIVES" fontName:@"Marker Felt" fontSize:30];
    [livesTitle setPosition:ccpAdd([self livesPosition], ccp(0, 30))];
    [livesTitle setColor:ccBLUE];
    [self addChild:livesTitle];

    // Build the display for the lives counter
    livesRemainingDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", livesRemaining] fontName:@"Market Feld" fontSize:30];
    [livesRemainingDisplay setPosition:[self livesPosition]];
    [self resetLivesColor];
    [self addChild:livesRemainingDisplay];
}

- (void)resetLivesColor
{
    // Change the Lives counter back to blue
    [livesRemainingDisplay setColor:ccBLUE];
}

- (CGPoint)scorePosition
{
    return ccp(size.width - 10 - tileSize.width / 2, (size.height / 4) * 3);
}

- (CGPoint)livesPosition
{
    return ccp(size.width - 10 - tileSize.width / 2, (size.height / 4));
}


- (void)calculateLivesRemaining
{

}

- (void)generateTileGrid
{

}

- (void)acquireMemoryTiles
{

}

- (void)preloadEffects
{

}

- (void)dealloc
{
    [tilesAvailable release];
    [tilesSelected release];
    [tilesInPlay release];

    [super dealloc];
}


@end
