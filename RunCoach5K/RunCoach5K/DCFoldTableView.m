//
//  DCFoldTableView.m
//  Daily Carb
//
//  Created by Maxwell YQ003 on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SECTION_SIZE CGRectMake(0, 0, 768, 40)
#define SECTION_BG_SIZE CGRectMake(-10, 0, 768, 51)

#define SECTION_SIZE_IPONE CGRectMake(0, 0, 320, 44)
#define SECTION_BG_SIZE_IPONE CGRectMake(0, 0, 320, 44)

#define SECTION_IMAGE_SHOW [UIImage imageNamed:@"sec_hd_open_ipad"]
#define SECTION_IMAGE_HIDE [UIImage imageNamed:@"sec_hd_close_ipad"]

#define SECTION_IMAGE_SHOW_IPONE [UIImage imageNamed:@"sec_hd_open"]
#define SECTION_IMAGE_HIDE_IPONE [UIImage imageNamed:@"sec_hd_closed"]

#define SECTION_IMAGE_BG [UIImage imageNamed:@"cell_bg_44px"]

#import "DCFoldTableView.h"

@implementation DCFoldTableView

@synthesize isFoldArray = _isFoldArray;
@synthesize dcdelegate = _dcdelegate;
@synthesize dcdataSource = _dcdataSource;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.clipsToBounds = NO;
    }
    return self;
}



#pragma mark - FoldBtnAction
- (void)foldBtnAction:(id)sender{
    
    UIButton* foldBtn = (UIButton*)sender;
    NSInteger section = foldBtn.tag;
    if (section < 0) {
        section = -section - 1;
        BOOL isFold = [[self.isFoldArray objectAtIndex:section] boolValue];
        if (self.frame.size.width <= 320) {
            if (isFold) {
                [foldBtn setImage:SECTION_IMAGE_HIDE_IPONE forState:UIControlStateNormal];
            }else {
                [foldBtn setImage:SECTION_IMAGE_SHOW_IPONE forState:UIControlStateNormal];
            }
        }else{
            if (isFold) {
                [foldBtn setImage:SECTION_IMAGE_HIDE forState:UIControlStateNormal];
            }else {
                [foldBtn setImage:SECTION_IMAGE_SHOW forState:UIControlStateNormal];
            }
        }
        
        [self.isFoldArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isFold]];
        
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        if ([self.dcdelegate respondsToSelector:@selector(DCFoldTable:didSelectSection:)]) {
            [self.dcdelegate DCFoldTable:self didSelectSection:section];
        }
    }
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCFoldTable:accessoryButtonTappedForRowWithIndexPath:)]) {
        [_dcdelegate DCFoldTable:self accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCFoldTable:didSelectRowAtIndexPath:)]) {
        [_dcdelegate DCFoldTable:tableView didSelectRowAtIndexPath:indexPath];
    }
    [self performSelector:@selector(deselectCellAtRow:) withObject:indexPath afterDelay:0.3f];
}
- (void)deselectCellAtRow:(id)sender{
    NSIndexPath *path = (NSIndexPath*)sender;
    [self deselectRowAtIndexPath:path animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCFoldTable:heightForRowAtIndexPath:)]) {
        return [_dcdelegate DCFoldTable:tableView heightForRowAtIndexPath:indexPath];
    }else {
        return 44;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    int height = -1;
    if ([self.dcdelegate respondsToSelector:@selector(DCtableView:heightForHeaderInSection:)]) {
        height = [self.dcdelegate DCtableView:tableView heightForHeaderInSection:section];
    }
    if (height >= 0) {
        return height;
    }
    if (tableView.frame.size.width <= 320) {
        CGRect r = SECTION_SIZE_IPONE;
        return r.size.height;
    }else{
        CGRect r = SECTION_SIZE;
        return r.size.height;
    }
}
- (UIView*)tableView:(UITableView*)tableView sectionViewInSection:(NSInteger)section{
    if ([_dcdataSource respondsToSelector:@selector(DCFoldTable:ViewForHeaderInSection:)]) {
        return [_dcdataSource DCFoldTable:tableView ViewForHeaderInSection:section];
    }
    CGRect      frame;
    if (tableView.frame.size.width <= 320) {
        frame = SECTION_SIZE_IPONE;
    }else{
        frame = SECTION_SIZE;
    }
    UIView*     headerView = [[UIView alloc] 
                               initWithFrame:frame];
    headerView.backgroundColor = [UIColor grayColor];
    UIImageView *bg = [[UIImageView alloc]
                       initWithImage:SECTION_IMAGE_BG];
    if (tableView.frame.size.width <= 320) {
        bg.frame = SECTION_BG_SIZE_IPONE;
    }else{
        bg.frame = SECTION_BG_SIZE;
    }
    UILabel*    titleLbl = [[UILabel alloc]
                            initWithFrame:CGRectMake(bg.frame.origin.x, 0, bg.frame.size.width, frame.size.height)];
    titleLbl.textColor         = [UIColor blackColor];
    if (tableView.frame.size.width <= 320) {
        titleLbl.font              = [UIFont boldSystemFontOfSize:17];
    }else{
        titleLbl.font              = [UIFont boldSystemFontOfSize:25];
    }
    titleLbl.backgroundColor   = [UIColor clearColor];
    titleLbl.textAlignment     = UITextAlignmentCenter;
    if ([_dcdataSource respondsToSelector:@selector(DCFoldTable:titleForHeaderInSection:)]) {
        titleLbl.text              = [_dcdataSource DCFoldTable:tableView titleForHeaderInSection:section];
    }
    [headerView addSubview:bg];
    [headerView addSubview:titleLbl];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* headerView = [self tableView:tableView sectionViewInSection:section];
    
//    UIButton*   foldBtn = [[UIButton alloc]
//                            initWithFrame:CGRectMake(0, 0, headerView.frame.size.width,
//                                                     headerView.frame.size.height)];
//    [foldBtn addTarget:self 
//                action:@selector(foldBtnAction:) 
//      forControlEvents:UIControlEventTouchUpInside];
//    foldBtn.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:foldBtn];
//    foldBtn.tag = section;
    
    UIButton * showBtn = [[UIButton alloc]
                          initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    [showBtn addTarget:self
                action:@selector(foldBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    showBtn.backgroundColor = [UIColor clearColor];
    showBtn.tag = -1 - section;
    showBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 260, 0, 0);
    BOOL isFold = [[self.isFoldArray objectAtIndex:section] boolValue];
    if (self.frame.size.width <= 320) {
        if (isFold) {
            [showBtn setImage:SECTION_IMAGE_HIDE_IPONE forState:UIControlStateNormal];
        }else {
            [showBtn setImage:SECTION_IMAGE_SHOW_IPONE forState:UIControlStateNormal];
        }
    }else{
        if (isFold) {
            [showBtn setImage:SECTION_IMAGE_HIDE forState:UIControlStateNormal];
        }else {
            [showBtn setImage:SECTION_IMAGE_SHOW forState:UIControlStateNormal];
        }
    }
    [headerView addSubview:showBtn];
    return headerView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCtableView:editingStyleForRowAtIndexPath:)]) {
       return [_dcdelegate  DCtableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCtableView:didEndEditingRowAtIndexPath:)]) {
        [_dcdelegate DCtableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if ([_dcdelegate respondsToSelector:@selector(DCtableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [_dcdelegate DCtableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }else {
        return proposedDestinationIndexPath;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = [_dcdataSource numberOfSectionsInDCFoldTable:tableView];
    if (self.isFoldArray == nil || self.isFoldArray.count != sections) {
        [self.isFoldArray removeAllObjects];
        self.isFoldArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < sections; i++) {
            [self.isFoldArray addObject:[NSNumber numberWithBool:i == 0 ? false : true]];
        }
    }
    return sections;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        BOOL isFold = [[self.isFoldArray objectAtIndex:section] boolValue];
        if (isFold) {
            return 0;
        }else {
            return [_dcdataSource DCFoldTable:tableView numberOfRowsInSection:section];
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_dcdataSource DCFoldTable:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdataSource respondsToSelector:@selector(DCFoldTable:commitEditingStyle:forRowAtIndexPath:)]) {
        [_dcdataSource DCFoldTable:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdataSource respondsToSelector:@selector(DCFoldTable:canMoveRowAtIndexPath:)]) {
        return [_dcdataSource DCtableView:tableView canMoveRowAtIndexPath:indexPath];
    }else {
        return NO;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dcdataSource respondsToSelector:@selector(DCFoldTable:canEditRowAtIndexPath:)]) {
        return [_dcdataSource DCFoldTable:tableView canEditRowAtIndexPath:indexPath];
    }else {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if ([_dcdataSource respondsToSelector:@selector(DCtableView:moveRowAtIndexPath:toIndexPath:)]) {
        [_dcdataSource DCtableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

-(void)showIndexPath:(NSIndexPath *)indexPath{
    [self.isFoldArray replaceObjectAtIndex:indexPath.section
                                withObject:[NSNumber numberWithBool:false]];
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
        withRowAnimation:UITableViewRowAnimationNone];
    if ([self numberOfRowsInSection:indexPath.section] > indexPath.row) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }else{
        [self scrollRectToVisible:[self rectForSection:indexPath.section] animated:YES];
    }
}


@end
