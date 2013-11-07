//
//  HHHHEmojiKeyboardTextKeyCell.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHEmojiKeyboardTextKeyCell.h"

@implementation HHEmojiKeyboardTextKeyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyButton.bounds = self.bounds;
        self.keyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.keyButton setTitleColor:[UIColor colorWithWhite:41 / 255.0 alpha:1] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backgroundColor = nil;
    }
}
@end
