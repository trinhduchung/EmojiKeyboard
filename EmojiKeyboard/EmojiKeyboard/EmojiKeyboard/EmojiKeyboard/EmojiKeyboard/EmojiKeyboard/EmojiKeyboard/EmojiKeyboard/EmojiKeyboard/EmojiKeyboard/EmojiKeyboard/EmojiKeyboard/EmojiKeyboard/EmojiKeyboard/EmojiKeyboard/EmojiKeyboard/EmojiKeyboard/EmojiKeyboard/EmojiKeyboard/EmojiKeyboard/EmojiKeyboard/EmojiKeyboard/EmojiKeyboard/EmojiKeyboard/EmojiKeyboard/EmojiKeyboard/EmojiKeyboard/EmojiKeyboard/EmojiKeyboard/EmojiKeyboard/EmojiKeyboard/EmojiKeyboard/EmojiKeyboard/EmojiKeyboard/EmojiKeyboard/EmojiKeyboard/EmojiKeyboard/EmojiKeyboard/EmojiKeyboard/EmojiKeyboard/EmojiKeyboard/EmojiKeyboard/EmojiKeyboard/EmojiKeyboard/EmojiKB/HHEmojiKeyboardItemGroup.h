//
//  HHEmojiKeyboardItemGroup.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHEmojiKeyboardItemGroup : NSObject
@property (nonatomic,copy)              NSString                 *title;
@property (nonatomic,strong)            UIImage                  *image;
@property (nonatomic,strong)            UIImage                  *selectedImage;

@property (nonatomic,strong)            NSArray                  *keyItems;

/* CollectionViewLayout for this keyItemGroup, this property has a default value. Using WUEmoticonsKeyboardKeysPageFlowLayout is recommanded. */
@property (nonatomic,strong)            UICollectionViewLayout   *keyItemsLayout;

/* CollectionViewCell class for this keyItemGroup. default is WUEmoticonsKeyboardKeyCell.class */
@property (nonatomic,unsafe_unretained) Class                     keyItemCellClass;
@end
