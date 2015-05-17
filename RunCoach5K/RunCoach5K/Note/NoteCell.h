//
//  NoteCell.h
//  BillsMonitor
//
//  Created by  YQ006 on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteChanged

- (void) noteChanged:(NSString *)note;

@end

@class NoteViewController;
@interface NoteCell : UITableViewCell <
NoteChanged
>{
    UILabel                                             *noteLabel;
    NoteViewController                                  *noteViewController;
    NSString *editedKey;
}

@property (nonatomic, strong) NSString  		*string;
@property (nonatomic, readonly) NoteViewController      *noteViewController;
@property (nonatomic, readonly) CGFloat         noteCellHeight;
@property (nonatomic, weak) id editedObject;
@property (nonatomic, strong) NSString *editedKey;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier 
               tableViewStyle:(UITableViewStyle)tbStyle;

+ (NSString *) identifier;


@end
