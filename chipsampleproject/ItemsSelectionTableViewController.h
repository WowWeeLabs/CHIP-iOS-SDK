//
//  ItemsSelectionTableViewController.h
//  Sample Project
//
//  Created by David Chan on 3/4/17.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemsSelectionTableViewCallback <NSObject>

- (void)didSelectRow:(int)selection Mode:(int)_mode;

@end

enum ItemsSelectionTableViewControllerMode {
    ItemsSelectionTableViewControllerMode_Alarm,
    ItemsSelectionTableViewControllerMode_Drive,
    ItemsSelectionTableViewControllerMode_Setting,
    ItemsSelectionTableViewControllerMode_FileSelection,
    ItemsSelectionTableViewControllerMode_InteractionSelection,
    ItemsSelectionTableViewControllerMode_AnimationSelection,
    ItemsSelectionTableViewControllerMode_ImageSelection,
    ItemsSelectionTableViewControllerMode_SoundSelection,
    ItemsSelectionTableViewControllerMode_ImageTemplateSelection,
};

@interface ItemsSelectionTableViewController : UITableViewController {
    
}

@property (nonatomic, readwrite) NSArray *arrItems;
@property (assign, readwrite) int mode;
@property (nonatomic, readwrite) id<ItemsSelectionTableViewCallback> delegate;

@end
