//
//  FactoryMenuViewController.m
//  Sample Project
//
//  Created by David Chan on 3/4/17.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "SDKMenuViewController.h"

@implementation SDKMenuViewController

static SDKMenuViewController* _factoryMenuViewController = nil;

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _factoryMenuViewController = self;
    
    [self.firmwareLabel setText:[NSString stringWithFormat:@""]];
    
    self.remoteArr = [NSArray arrayWithObjects:@"Move Forward", @"Move Backward", @"Move Left", @"Move Right", @"Turn Left", @"Turn Right", nil];
    
    self.settingArr = @[@"Read Firmware Version", @"Detect Battery", @"Get Volume", @"Set Volume", @"Get Eye Brightness", @"Set Eye Brightness", @"Get Adult or Kid Speed", @"Set Adult or Kid Speed", @"Force Sleep"];
    
    self.interactionArr = @[@"Play Animation", @"Play Sound"];
    
    self.animationPathArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AnimationList.plist" ofType:nil]];
    
    self.soundPathArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SoundList.plist" ofType:nil]];
    
    self.selectionMenuArr = @[@"Interaction", @"Drive", @"Alarm", @"Setting"];
    
    self.alarmMenuArr = @[@"Set Current Clock", @"Get Current Alarm", @"Set Alarm", @"Cancel Alarm"];
    
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot * robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        [robot setDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.menuTable reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - ItemsSelectionTableViewCallback
- (void)didSelectRow:(int)selection Mode:(int)_mode {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot * robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        switch (_mode) {
            case ItemsSelectionTableViewControllerMode_Drive:
                switch (selection) {
                    case 0:
                        [robot chipDrive:CGVectorMake(0, 1) spinVector:CGVectorMake(0, 0)];
                        break;
                    case 1:
                        [robot chipDrive:CGVectorMake(0, -1) spinVector:CGVectorMake(0, 0)];
                        break;
                    case 2:
                        [robot chipDrive:CGVectorMake(-1, 0) spinVector:CGVectorMake(0, 0)];
                        break;
                    case 3:
                        [robot chipDrive:CGVectorMake(1, 0) spinVector:CGVectorMake(0, 0)];
                        break;
                    case 4:
                        [robot chipDrive:CGVectorMake(0, 0) spinVector:CGVectorMake(-1, 0)];
                        break;
                    case 5:
                        [robot chipDrive:CGVectorMake(0, 0) spinVector:CGVectorMake(1, 0)];
                        break;
                    default:
                        break;
                }
                break;
            case ItemsSelectionTableViewControllerMode_Setting:
                if (selection == 0) {
                    [robot readChipFirmwareVersion];
                }
                else if (selection == 1) {
                    [robot chipGetBatteryLevel];
                }
                else if (selection == 2) {
                    [self getVolume];
                }
                else if (selection == 3) {
                    [self setVolume];
                }
                else if (selection == 4) {
                    [robot chipGetEyeRGBBrightness];
                }
                else if (selection == 5) {
                    [self setEyeBrightness];
                }
                else if (selection == 6) {
                    [robot chipGetAdultOrKidSpeed];
                }
                else if (selection == 7) {
                    [self setAdultOrKidSpeed];
                }
                else if (selection == 8) {
                    [robot chipForceSleep];
                }
                break;
            case ItemsSelectionTableViewControllerMode_InteractionSelection:
                if (selection == 0) {
                    [self showAnimationList];
                }
                else if (selection == 1) {
                    [self showSoundList];
                }
                break;
            case ItemsSelectionTableViewControllerMode_AnimationSelection:
                [robot chipPlayBodycon:selection+1];
                break;
            case ItemsSelectionTableViewControllerMode_SoundSelection:
                if (selection == 0) {
                    [robot chipStopSound];
                }
                else {
                    [robot chipPlaySoundWithEnum:(kChipSoundFileValue)selection];
                }
                break;
            case ItemsSelectionTableViewControllerMode_Alarm:
                if (selection == 0) {
                    [self setCurrentTime];
                }
                else if (selection == 1) {
                    [robot chipGetCurrentAlarm];
                }
                else if (selection == 2) {
                    [self setAlarm];
                }
                else if (selection == 3) {
                    [self cancelAlarm];
                }
                break;
        }
    }
}

#pragma mark - Interating Methods
- (void)showAnimationList {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
    controller.arrItems = self.animationPathArr;
    controller.delegate = self;
    controller.mode = ItemsSelectionTableViewControllerMode_AnimationSelection;
    [self.navigationController pushViewController:controller animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)showSoundList {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
    controller.arrItems = self.soundPathArr;
    controller.delegate = self;
    controller.mode = ItemsSelectionTableViewControllerMode_SoundSelection;
    [self.navigationController pushViewController:controller animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Setting Methods
- (void)getVolume {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        [robot chipGetVolumeLevel];
        
        UIAlertController *alertController = nil;
        NSString* titleString = @"Volume";
        NSString* msgString = [NSString stringWithFormat:@"Value: %d", (int)robot.chipVolume];
        
        alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setVolume {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Volume" message:@"Please enter volume level" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Value (0-11)";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *sizeString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if (![sizeString isEqualToString:@""]) {
                if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
                    [robot chipSetVolumeLevel:[sizeString intValue]];
                }
            }
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setEyeBrightness {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Eyes LED Brightness" message:@"Please enter LED brightness level" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Value (0-255)";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *sizeString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if (![sizeString isEqualToString:@""]) {
                if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
                    [robot chipSetEyeRGBBrightness:[sizeString intValue]];
                }
            }
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setAdultOrKidSpeed {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Adult/Kid Speed" message:@"Please set Chip speed setting" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Value (0: Adult | 1: Kid)";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *sizeString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if (![sizeString isEqualToString:@""]) {
                if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
                    [robot chipSetAdultOrKidSpeed:[sizeString intValue]];
                }
            }
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Alarm Methods
- (void)setCurrentTime {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        NSDate *now = [NSDate date];
        unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:now];
        int weekOfDay = (int)components.weekday-1;
        [robot chipSetCurrentClockWithYear:(int)components.year withMonth:(int)components.month withDay:(int)components.day withHour:(int)components.hour withMin:(int)components.minute withSec:(int)components.second withDayOfWeek:weekOfDay];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alarm" message:@"Set Current Time Success" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setAlarm {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alarm" message:@"Please enter alarm" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Hours (0-24)";
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Minutes (0-60)";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *hourString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            NSString *minString = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
            if (![hourString isEqualToString:@""] && ![minString isEqualToString:@""]) {
                if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
                    int hour = [hourString intValue];
                    int minute = [minString intValue];
                    BOOL isNextDay = NO;
                    NSDate *now = [NSDate date];
                    unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:now];
                    
                    if(hour < components.hour) {
                        isNextDay = YES;
                    }
                    else if(hour == components.hour) {
                        if(minute < components.minute) {
                            isNextDay = YES;
                        }
                    }
                    NSDate *newDate = now;
                    if(isNextDay) {
                        newDate = [now dateByAddingTimeInterval:86400]; // add one day
                    }
                    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:units fromDate:newDate];
                    [robot chipSetAlarmWithYear:(int)newComponents.year withMonth:(int)newComponents.month withDay:(int)newComponents.day withHour:hour withMin:minute];
                }
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cancelAlarm {
    if ([[ChipRobotFinder sharedInstance] firstConnectedChip] != nil) {
        ChipRobot *robot = [[ChipRobotFinder sharedInstance] firstConnectedChip];
        [robot chipCancelAlarm];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alarm" message:@"Cancel Alarm Success" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectionMenuArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifierString = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    
    [cell.textLabel setText:[self.selectionMenuArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == SDKMenuMode_Alarm) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.alarmMenuArr;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_Alarm;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Drive) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.remoteArr;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_Drive;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Setting) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.settingArr;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_Setting;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Interaction) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.interactionArr;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_InteractionSelection;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)chipRobot:(ChipRobot*)chip didReceivedBatteryLevel:(float)batteryLevel withChargingStatus:(kChipChargingStatus)chargingStatus withChargerType:(kChipChargerType)chargerType {
    UIAlertController *alertController = nil;
    NSString* titleString = @"Battery Level";
    NSString* msgString = [NSString stringWithFormat:@"Value: %f", batteryLevel];
    
    alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)chipRobot:(ChipRobot*)chip didReceiveDogVersionWithBodyHardware:(NSString*)chipVerBodyHardwareVer headHardware:(NSString*)chipVerHeadHardwareVer mechanicVer:(NSString*)chipVerMechanic bleSpiFlashVer:(NSString*)chipVerBleSpiFlash nuvotonSpiFlashVer:(NSString*)chipVerNuvotonSpiFlash bleBootloaderVer:(NSString*)chipVerBleBootloader bleApromFirmware:(NSString*)chipVerBleApromFirmware nuvotonBootloaderFirmware:(NSString*)chipVerNuvotonBootloaderFirmware nuvotonApromFirmware:(NSString*)chipVerNuvotonApromFirmware nuvotonVr:(NSString*)chipVerNuvotonVR {
    
    UIAlertController *alertController = nil;
    NSString* titleString = @"Firmware";
    NSString* msgString = [NSString stringWithFormat:@"BLE BootloaderVer: %@\nBLE Aprom Firmware: %@\nNuvoton Bootloader Firmware: %@\nNuvoton Aprom Firmware: %@\nNuvoton Version: %@", chipVerBleBootloader, chipVerBleApromFirmware, chipVerNuvotonBootloaderFirmware, chipVerNuvotonApromFirmware, chipVerNuvotonVR];
    
    alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)chipRobot:(ChipRobot *)chip didReceiveEyeRGBBrightness:(int)brightness {
    UIAlertController *alertController = nil;
    NSString* titleString = @"Eye RGB Brightness";
    NSString* msgString = [NSString stringWithFormat:@"Value: %d", brightness];
    
    alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)chipRobot:(ChipRobot *)chip didReceiveAdultOrKidSpeed:(kChipSpeed)speed {
    UIAlertController *alertController = nil;
    NSString* titleString = @"Adult or Kid Speed";
    NSString* msgString = (speed==kChipAdultSpeed)?@"Adult Speed":@"Kid Speed";
    
    alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)chipRobot:(ChipRobot *)chip didReceiveCurrentAlarmWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMinute:(int)minute {
    UIAlertController *alertController = nil;
    NSString* titleString = @"Alarm";
    NSString* msgString = [NSString stringWithFormat:@"Current Alarm: %02d/%02d %02d:%02d", day, month, hour, minute];
    
    alertController = [UIAlertController alertControllerWithTitle:titleString message:msgString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
