//
//  FactoryMenuViewController.h
//  Sample Project
//
//  Created by David Chan on 3/4/17.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WowweeChipSDK/WowweeChipSDK.h>
#import "ItemsSelectionTableViewController.h"
#import "LoadingView.h"

typedef enum _SDKTestMenuMode {
    SDKMenuMode_Interaction = 0,
    SDKMenuMode_Drive = 1,
    SDKMenuMode_Alarm = 2,
    SDKMenuMode_Setting = 3,
}SDKMenuMode;

@interface SDKMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ItemsSelectionTableViewCallback, ChipRobotDelegate> {
    int                     selectedImageIndex;
}

#pragma mark - Interating Methods
- (void)showAnimationList;
- (void)showSoundList;

#pragma mark - Setting Methods
- (void)getVolume;
- (void)setVolume;
- (void)setEyeBrightness;
- (void)setAdultOrKidSpeed;

#pragma mark - Alarm Methods
- (void)setCurrentTime;
- (void)setAlarm;
- (void)cancelAlarm;

#pragma mark - Property
@property (readwrite, atomic) IBOutlet UITableView      *menuTable;
@property (readwrite, atomic) IBOutlet UILabel          *firmwareLabel;
@property (nonatomic, readwrite) NSArray                *ledColorArr;
@property (nonatomic, readwrite) NSArray                *remoteArr;
@property (nonatomic, readwrite) NSArray                *settingArr;
@property (nonatomic, readwrite) NSArray                *interactionArr;
@property (nonatomic, readwrite) NSArray                *animationPathArr;
@property (nonatomic, readwrite) NSArray                *imagePathArr;
@property (nonatomic, readwrite) NSArray                *soundPathArr;
@property (nonatomic, readwrite) NSArray                *imageTemplateArr;

@property (nonatomic, readwrite) NSArray                *selectionMenuArr;
@property (nonatomic, readwrite) NSArray                *alarmMenuArr;

@end
