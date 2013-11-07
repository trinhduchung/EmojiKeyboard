//
//  HHEmojiKeyboardCell.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEmojiKeyboardItem.h"

@interface HHEmojiKeyboardCell : UICollectionViewCell
@property (nonatomic,weak,readonly) UIButton *keyButton;
@property (nonatomic,strong) HHEmojiKeyboardItem *keyItem;
@end
