//
//  ChipSDKConfig.h
//  WowweeChipSDK
//
//  Created by Forrest Chan on 02/11/15.
//  Copyright (c) 2015 WowWee Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// These can be overridden by defining them before importing the SDK

typedef enum {
    MRFChipScanOptionMask_ShowAllDevices       = 0,
    MRFChipScanOptionMask_FilterByProductId    = 1 << 0,
    MRFChipScanOptionMask_FilterByServices     = 1 << 1,
    MRFChipScanOptionMask_FilterByDeviceName   = 1 << 2,
} ChipFinderScanOptions;

#ifndef CHIP_SCAN_OPTIONS
#define CHIP_SCAN_OPTIONS MRFChipScanOptionMask_ShowAllDevices | MRFChipScanOptionMask_FilterByProductId
//#define CHIP_SCAN_OPTIONS MRFChipScanOptionMask_ShowAllDevices
#endif

@interface ChipSDKConfig : NSObject
@end
