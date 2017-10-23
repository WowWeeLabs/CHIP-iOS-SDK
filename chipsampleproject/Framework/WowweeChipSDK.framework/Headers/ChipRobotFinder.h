/*
 * Copyright 2010-2015 WowWee Group Ltd, All Rights Reserved.
 *
 * Licensed under the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <CoreBluetooth/CoreBluetooth.h>

#import "ChipRobot.h"
#import "BluetoothRobotFinder.h"

FOUNDATION_EXPORT NSString *const ChipRobotFinderNotificationID;
FOUNDATION_EXPORT bool const CHIP_ROBOT_FINDER_DEBUG_MODE;

/**
 These are the values that can be sent from EmojiBotFinder
 */
typedef enum : NSUInteger {
    ChipRobotFinderNote_ChipRobotFound = 1,
    ChipRobotFinderNote_ChipRobotListCleared,
    ChipRobotFinderNote_BluetoothError,
    ChipRobotFinderNote_BluetoothIsOff,
    ChipRobotFinderNote_BluetoothIsAvailable,
} ChipRobotFinderNote;

@interface ChipRobotFinder : BluetoothRobotFinder <CBCentralManagerDelegate>

/**

 */
@property (nonatomic, strong, readonly) NSMutableArray *robotsFound;
@property (nonatomic, strong, readonly) NSMutableArray *robotsConnected;
@property (nonatomic, assign, readonly) CBCentralManagerState cbCentralManagerState;
@property (nonatomic, assign) uint16_t scanFoundProductId;
@property (nonatomic, assign) int rssiLimit;

/**
 Starts the BLE scanning
 */
-(void)scanForRobots;

/**
 Starts the BLE scanning for a specified number of seconds. Normally you should use this method because endlessly scanning is very battery intensive.
 */
-(void)scanForRobotsForDuration:(NSUInteger)seconds;
-(void)stopScanForRobots;
-(void)clearFoundRobotList;

/**
 Quick access to first connected EmojiBot in EmojiBotsConnected list
 @return EmojiBotsConnected[0] or nil if EmojiBotsConnected is empty
 */
-(ChipRobot *)firstConnectedChip;

@end
