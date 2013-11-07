//
//  HHEmojiKeyboardItem.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHEmojiKeyboardItem : NSObject
@property (nonatomic,copy)    NSString *title;
@property (nonatomic,strong)  UIImage  *image;
@property (nonatomic,copy)    NSString *textToInput;
@end
