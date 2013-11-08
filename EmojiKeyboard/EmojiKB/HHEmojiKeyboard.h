//
//  HHEmojiKeyboard.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEmojiKeyboardItemGroup.h"
#import "HHEmojiKeyboardItem.h"
#import "HHEmojiKeyboardKeyPageFlowLayout.h"
#import "HHEmojiKeyboardCell.h"

extern NSString * const WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification;

extern CGSize const WUEmoticonsKeyboardDefaultSize;

typedef NS_ENUM(NSUInteger, WUEmoticonsKeyboardButton) {
    WUEmoticonsKeyboardButtonKeyboardSwitch,
    WUEmoticonsKeyboardButtonBackspace
};

@interface HHEmojiKeyboard : UIView <UIAppearance,UIAppearanceContainer>

@property (nonatomic)      BOOL    enableStandardSystemKeyboardClickSound;

/*
 an array of WUEmoticonsKeyboardKeyItemGroup.
 */
@property (nonatomic,copy) NSArray *keyItemGroups;
@property (nonatomic,strong)         NSArray                            *keyItemGroupViews;
@property (nonatomic,copy) void    (^keyItemGroupPressedKeyCellChangedBlock)(HHEmojiKeyboardItemGroup *keyItemGroup, HHEmojiKeyboardCell *fromKeyCell, HHEmojiKeyboardCell *toKeyCell);
/*
 Note:
 Use the `UIResponder (WUEmoticonsKeyboard)` -switchToEmoticonsKeyboard: method to make a textInput switch to a WUEmoticonsKeyboard.
 The textInput object will retain the WUEmoticonsKeyboard which attached to it.
 
 You may get the WUEmoticonsKeyboard object though the textInput's inputView or emoticonsKeyboard property.
 */
@property (nonatomic,weak,readonly) UIResponder<UITextInput> *textInput;

+ (instancetype)keyboard;

#pragma mark - Apperance

- (void)setBackgroundImage:(UIImage *)image UI_APPEARANCE_SELECTOR;
- (void)setBackgroundImage:(UIImage *)image forKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup UI_APPEARANCE_SELECTOR;
- (void)setBackgroundColor:(UIColor *)backgroundColor forKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup UI_APPEARANCE_SELECTOR;
/*
- (void)setImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)imageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state;

- (void)setBackgroundImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)backgroundImageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state;
 */

@property (nonatomic) CGFloat toolsViewHeight UI_APPEARANCE_SELECTOR; //Default 45.0f

@end

@interface UIResponder (HHEmojiKeyboard)
@property (readonly, strong) HHEmojiKeyboard *emoticonsKeyboard;
- (void)switchToDefaultKeyboard;
- (void)switchToEmoticonsKeyboard:(HHEmojiKeyboard *)keyboard;
@end
