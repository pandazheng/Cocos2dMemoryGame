#import "MTPlayfieldLayer.h"
#import "MTMemoryTile.h"
#import "MTMenuScene.h"

#define SND_TILE_FLIP @"button.caf"
#define SND_TILE_SCORE @"whoosh.caf"
#define SND_TILE_WRONG @"buzzer.caf"
#define SND_SCORE @"harprun.caf"

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
        boardWidth = 400;
        boardHeight = 320;

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

        float tileHeight = ((boardHeight - (boardRows * padHeight)) / boardRows) - padHeight;

        // Force the tiles to be square
        if (tileWidth > tileHeight) {
            tileWidth = tileHeight;
        } else {
            tileHeight = tileWidth;
        }

        // Store the tileSize so we can use it later
        tileSize = CGSizeMake(tileWidth, tileHeight);

        // Set the offset from the edge
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

- (void)dealloc
{
    [tilesAvailable release];
    [tilesSelected release];
    [tilesInPlay release];
    [super dealloc];
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
    livesRemainingDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", livesRemaining] fontName:@"Marker Felt" fontSize:30];
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
    // this method takes the tilesAvailable array, and deals the giles out to the board randomly
    // Tiles used will be moved to the tilesInPlay array
    for (NSInteger newRow = 1; newRow <= boardRows; newRow++) {
        for (NSInteger newCol = 1; newCol <= boardColumns; newCol++) {
            // randomize each card slot
            NSInteger rndPick = (NSInteger) arc4random() % ([tilesAvailable count]);

            // Grab the MemoryTile from the array
            MTMemoryTile *newTile = [tilesAvailable objectAtIndex:rndPick];

            // Let the card 'know' where it is
            [newTile setTileRow:newRow];
            [newTile setTileColumn:newCol];

            // Scale the tile to size
            float tileScaleX = tileSize.width / newTile.contentSize.width;

            // We scale by X only because tiles are square
            [newTile setScale:tileScaleX];

            // Set the position for the tile
            [newTile setPosition:[self tilePosforRow:newRow andColumn:newCol]];

            // Add the tile as a child of our batch node
            [self addChild:newTile];

            // Since we don't want to reuse this tile, we remove it from the array.
            [tilesAvailable removeObjectAtIndex:rndPick];

            // We retain the Memory tile for later access
            [tilesInPlay addObject:newTile];
        }
    }
}

- (void)acquireMemoryTiles
{
    // the tilesAvailable array will be the only retain we have on the tiles.
    for (int count = 1; count <= maxTiles; count++) {
        for (NSInteger tileNo = 1; tileNo <= 2; tileNo++) {
            NSString *imageName = [NSString stringWithFormat:@"tile%i.png", count];
            MTMemoryTile *newTile = [MTMemoryTile spriteWithSpriteFrameName:imageName];
            [newTile setFaceSprintName:imageName];
            [newTile showBack];

            [tilesAvailable addObject:newTile];
        }
    }
}

- (void)preloadEffects
{
    // Preload all of our sound effects
    [[SimpleAudioEngine sharedEngine] preloadEffect:SND_TILE_FLIP];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SND_TILE_SCORE];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SND_TILE_WRONG];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SND_SCORE];
}

- (CGPoint)tilePosforRow:(NSInteger)rowNum andColumn:(NSInteger)colNum
{
    float newX = boardOffsetX + (tileSize.width + padWidth) * (colNum - .5);
    float newY = boardOffsetY + (tileSize.height + padHeight) * (rowNum - .5);
    return ccp(newX, newY);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // If game over, go back to the main menu on any touch
    if (isGameOver) {
        [[CCDirector sharedDirector] replaceScene:[MTMenuScene node]];
        return;
    }

    UITouch *touch = [touches anyObject];

    // 0,0 for Cocoa Touch is the upper left corner, whereas the 0,0 position for OpenGL is the lower left corner
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint glLocation = [[CCDirector sharedDirector] convertToGL:location]; // OpenGL location

    // If the back button was pressed, we exit
    if (CGRectContainsPoint([backButton boundingBox], glLocation)) {
        [[CCDirector sharedDirector] replaceScene:[MTMenuScene node]];
        return;
    }

    // If we have 2 tiles face up, do not respond
    if ([tilesSelected count] == 2) {
        return;
    }

    // Iterate through tilesInPlay to see which tile was touched
    for (MTMemoryTile *aTile in tilesInPlay) {

        if ([aTile containsTouchLocation:glLocation] && [aTile isFaceUp] == NO) {

            // Flip the tile
            [aTile flipTile];

            // Hold the tile in a buffer array
            [tilesSelected addObject:aTile];

            // Call the score/fail check
            if ([tilesSelected count] == 2) {
                // we delay so player can see tiles
                [self scheduleOnce:@selector(checkForMatch) delay:1.0];
                break;
            }
        }
    }
}

- (void)checkForMatch
{
    // get the memory tiles for comparison
    MTMemoryTile *tileA = tilesSelected[0];
    MTMemoryTile *tileB = tilesSelected[1];

    // see if the two tiles matched
    if ([tileA.faceSprintName isEqualToString:tileB.faceSprintName]) {
        // remove the matching tiles
        [self removeMemoryTile:tileA];
        [self removeMemoryTile:tileB];
    } else {
        // No match, flip the tiles back
        [tileA flipTile];
        [tileB flipTile];
    }

    // remove the tiles from tilesSelected
    [tilesSelected removeAllObjects];
}

- (void)removeMemoryTile:(MTMemoryTile *)tile
{
    [tile removeFromParentAndCleanup:YES];
}

@end
