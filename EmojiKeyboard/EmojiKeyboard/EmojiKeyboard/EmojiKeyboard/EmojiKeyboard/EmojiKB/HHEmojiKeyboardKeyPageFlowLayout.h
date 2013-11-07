//
//  HHEmojiKeyboardKeyPageFlowLayout.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHEmojiKeyboardKeyPageFlowLayout : UICollectionViewLayout
@property (nonatomic) CGSize       itemSize;
@property (nonatomic) CGFloat      lineSpacing;
@property (nonatomic) CGFloat      itemSpacing;
@property (nonatomic) UIEdgeInsets pageContentInsets;
@end
