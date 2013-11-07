//
//  UIResponder+WriteableInputView.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (WriteableInputView)
@property (readwrite, retain) UIView *inputView;
@end
