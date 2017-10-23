//
//  LoadingView.h
//  RoboBlue
//
//  Created by David Chan on 16/3/15.
//  Copyright (c) 2015 wowwee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingViewDelegate <NSObject>

- (void)didLoadingViewCancel:(id)sender;

@end

@interface LoadingView : UIView {
    BOOL didTapCancel;
}
#pragma mark - public method
- (void)show;
- (void)showWithAnimation:(BOOL)enableAnimation;
- (void)hide;
- (void)hideWithAnimation:(BOOL)enableAnimation;
- (void)setText:(NSString*)str;

@property (nonatomic, strong) IBOutlet UIView                   *blackView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView  *indicatorView;
@property (nonatomic, strong) IBOutlet UILabel                  *label;
@property (readwrite,atomic) id<LoadingViewDelegate>  delegate;
@end
