//
//  LoadingView.m
//  RoboBlue
//
//  Created by David Chan on 16/3/15.
//  Copyright (c) 2015 wowwee. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

#pragma mark - public method
- (void)show {
    [self showWithAnimation:NO];
}

- (void)showWithAnimation:(BOOL)enableAnimation {
    didTapCancel = NO;
    if (enableAnimation) {
        [self setHidden:NO];
        [self setAlpha:0.0f];
        
        [UIView animateWithDuration:0.5f animations:^ {
            [self setAlpha:1.0f];
        }completion:^(BOOL isCompleted) {
            if (isCompleted) {
                [self setUserInteractionEnabled:YES];
                [self.indicatorView startAnimating];
            }
        }];
    }
    else {
        [self setHidden:NO];
        [self setAlpha:1.0f];
        [self setUserInteractionEnabled:YES];
        [self.indicatorView startAnimating];
    }
    
//    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCancel)];
//    [self addGestureRecognizer:tapRecognizer];
}

- (void)hide {
    [self hideWithAnimation:NO];
}

- (void)hideWithAnimation:(BOOL)enableAnimation {
//    [self removeGestureRecognizer:tapRecognizer];
    if (enableAnimation) {
        [UIView animateWithDuration:0.5f animations:^ {
            [self setAlpha:0.0f];
        }completion:^(BOOL isCompleted) {
            if (isCompleted) {
                [self setHidden:YES];
                [self setUserInteractionEnabled:NO];
                [self.indicatorView stopAnimating];
            }
        }];
    }
    else {
        [self setAlpha:1.0f];
        [self setHidden:YES];
        [self setUserInteractionEnabled:NO];
        [self.indicatorView stopAnimating];
    }
}

- (void)setText:(NSString*)str {
    [self.label setText:str];
}

- (void)tapToCancel {
    [self.delegate didLoadingViewCancel:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!didTapCancel) {
        didTapCancel = YES;
        [self tapToCancel];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
