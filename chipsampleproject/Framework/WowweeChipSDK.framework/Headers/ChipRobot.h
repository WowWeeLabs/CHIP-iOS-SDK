//
//  ChipRobot.h
//  BluetoothRobotControlLibrary
//
//  Created by Forrest Chan on 02/11/15.
//  Copyright (c) 2015 WowWee Group Limited. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ChipCommandValues.h"
#import "BluetoothRobot.h"

@protocol ChipRobotDelegate;
@protocol ChipRobotActivationDelegate;

FOUNDATION_EXPORT NSString *const CHIP_CONNECTED_NOTIFICATION_NAME;
FOUNDATION_EXPORT NSString *const CHIP_DISCONNECTED_NOTIFICATION_NAME;

typedef enum : NSUInteger {
    CHIP = 0,
    BALL,
    WATCH,
    BASE
} ChipType;

@interface ChipRobot : BluetoothRobot

@property (nonatomic, assign) float batteryLevel;
@property (nonatomic, assign) NSInteger chipVolume;
@property (nonatomic, assign) kChipSpeed chipSpeed;

/** Delegate for receiving callbacks */
@property (nonatomic, weak) id<ChipRobotDelegate> delegate;

#pragma mark - Chip Protocal Methods
/**
 Read CHiP's firmware version.
 
 Firmware version will be returned asynchronously to ChipRobotDelegate's
 @code
 - (void)chipRobot:(ChipRobot *)chip didReceiveFirmwareVer:(NSString*)bleFwFirmwareVer withNuvotonFwVer:(NSString*)nuvotonFwFirmwareVer withBleBootloaderVer:(NSString*)bleBootloaderVer withMechanicVer:(NSString*)mechanicVer;
 @endcode
 */
- (void)readChipFirmwareVersion;

/**
 Set CHiP's volume level.
 
 @param volumeLevel
 Volume level between 0x01(Mute) - 0x0B(Max)
 */
- (void)chipSetVolumeLevel:(uint8_t)volumeLevel;

/**
 Get CHiP's battery level.
 
 Battery level will be returned asynchronously to ChipRobotDelegate's
 @code
 - (void)chipRobot:(ChipRobot*)chip didReceivedBatteryLevel:(float)batteryLevel withChargingStatus:(kChipChargingStatus)chargingStatus withChargerType:(kChipChargerType)chargerType;
 @endcode
 */
- (void)chipGetBatteryLevel;

/**
 Get CHiP's volume level.
 
 Volume level will be stored as @c ChipRobot object's @c chipVolume
 */
- (void)chipGetVolumeLevel;

/**
 Get CHiP's current clock.
 
 The clock will reset every time CHiP is powered off.
 */
- (void)chipGetCurrentClock;

/**
 Set CHiP's clock
 
 Set the current clock for the alarm to work properly
 */
- (void)chipSetCurrentClockWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMin:(int)min withSec:(int)sec withDayOfWeek:(int)dayOfWeek;

/**
 Set CHiP's alarm clock. CHiP will start barking once the current time has reached the alarm time. Please note that the alarm will be cancelled once CHiP is turned OFF
 */
- (void)chipSetAlarmWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMin:(int)min;

/**
 Cancel the alarm.
 */
- (void)chipCancelAlarm;

/**
 Get the current alarm
 
 Current alarm time will be returned asynchronously to ChipRobotDelegate's
 @code
 - (void)chipRobot:(ChipRobot *)chip didReceiveCurrentAlarmWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMinute:(int)minute;
 @endcode
 */
- (void)chipGetCurrentAlarm;

/**
 Set CHiP to Adult Speed or Kid Speed mode
 
 @param speed
 kChipAdultSpeed (Faster overall speed) or kChipKidSpeed (Slower overall speed)
 */
- (void)chipSetAdultOrKidSpeed:(kChipSpeed)speed;

/**
 Get the current speed mode
 
 Current speed mode will be returned asynchronously to ChipRobotDelegate's
 @code
 - (void)chipRobot:(ChipRobot *)chip didReceiveAdultOrKidSpeed:(kChipSpeed)speed;
 @endcode
 */
- (void)chipGetAdultOrKidSpeed;

/**
 Set CHiP eyes' brightness
 @param value
 0x00 (default brightness), 0x01 (min brightness) - 0xFF (max brightness)
 */
- (void)chipSetEyeRGBBrightness:(uint8_t)value;

/**
 Get current CHiP's eyes' brightness
 
 Current eyes' brightness will be returned asynchronously to ChipRobotDelegate's
 @code
 - (void)chipRobot:(ChipRobot *)chip didReceiveEyeRGBBrightness:(int)brightness;
 @endcode
 */
- (void)chipGetEyeRGBBrightness;

/**
 Force CHiP go sleep
 */
- (void)chipForceSleep;

#pragma mark - Sound Commands
/**
 Play sound from CHiP.
 @param soundValue
 Index of sound effect
 */
- (void)chipPlaySoundWithEnum:(kChipSoundFileValue)soundValue;

/**
 Stop current sound
 */
- (void)chipStopSound;

#pragma mark - Driving Commands
/** 
 Drive Chip at speed and direction of given normalized vector.
 @param vector Normalized vector (-1 <= dx <= 1, -1 <= dy <= 1)
 */
- (void)chipDrive:(CGVector)movementVector spinVector:(CGVector)spinVector;

#pragma mark - Bodycon
/**
 Command CHiP to play an animation
 @param bodycon
 Animation index.
 */
- (void)chipPlayBodycon:(kChipBodyconType)bodycon;

@end

#pragma mark - ChipRobotActivationDelegate
@protocol ChipRobotActivationDelegate <NSObject>
- (void)didReceiveChipRobot:(ChipRobot*)_robot settingsActivationStatus:(uint8_t)status;
@end

#pragma mark - Delegate Callbacks
@protocol ChipRobotDelegate <NSObject>
@optional
- (void)chipDeviceReady:(ChipRobot *)chip;
- (void)chipDeviceDisconnected:(ChipRobot *)chip error:(NSError *)error;
- (void)chipDeviceFailedToConnect:(ChipRobot *)chip error:(NSError *)error;
- (void)chipDeviceReconnecting:(ChipRobot *)chip;
- (void)chipDeviceWentToSleep:(ChipRobot *)chip batteryEmpty:(bool)batteryEmpty;
- (void)chipRobot:(ChipRobot *)chip didReceiveFirmwareVer:(NSString*)bleFwFirmwareVer withNuvotonFwVer:(NSString*)nuvotonFwFirmwareVer withBleBootloaderVer:(NSString*)bleBootloaderVer withMechanicVer:(NSString*)mechanicVer;
- (void)chipRobot:(ChipRobot*)chip didReceiveDogVersionWithBodyHardware:(NSString*)chipVerBodyHardwareVer headHardware:(NSString*)chipVerHeadHardwareVer mechanicVer:(NSString*)chipVerMechanic bleSpiFlashVer:(NSString*)chipVerBleSpiFlash nuvotonSpiFlashVer:(NSString*)chipVerNuvotonSpiFlash bleBootloaderVer:(NSString*)chipVerBleBootloader bleApromFirmware:(NSString*)chipVerBleApromFirmware nuvotonBootloaderFirmware:(NSString*)chipVerNuvotonBootloaderFirmware nuvotonApromFirmware:(NSString*)chipVerNuvotonApromFirmware nuvotonVr:(NSString*)chipVerNuvotonVR;
- (void)chipRobot:(ChipRobot*)chip didReceivedBatteryLevel:(float)batteryLevel withChargingStatus:(kChipChargingStatus)chargingStatus withChargerType:(kChipChargerType)chargerType;
- (void)chipRobot:(ChipRobot *)chip didReceiveBatteryUpdate:(int)batteryPercentage;
- (void)chipRobot:(ChipRobot *)chip didReceiveCurrentClockWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMin:(int)min withSec:(int)sec withDayOfWeek:(int)dayOfWeek;
- (void)chipRobot:(ChipRobot *)chip didReceiveAdultOrKidSpeed:(kChipSpeed)speed;
- (void)chipRobot:(ChipRobot *)chip didReceiveEyeRGBBrightness:(int)brightness;
- (void)chipRobot:(ChipRobot *)chip didReceiveCurrentAlarmWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMinute:(int)minute;

@end




