//
//  DCFoldTableView.h
//  Daily Carb
//
//  Created by Maxwell YQ003 on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCFoldTableDelegate <NSObject>

@optional
- (void)DCFoldTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)DCFoldTable:(UITableView *)tableView didSelectSection:(NSInteger)section;
- (CGFloat)DCFoldTable:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)DCFoldTable:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCellEditingStyle)DCtableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexpath;
-(void)DCtableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)DCtableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
-(CGFloat)DCtableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
@end


@protocol DCFoldTableDataSource <NSObject>

- (NSInteger)numberOfSectionsInDCFoldTable:(UITableView *)tableView;
- (NSInteger)DCFoldTable:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)DCFoldTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString*)DCFoldTable:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section;
- (UIView *)DCFoldTable:(UITableView*)tableView ViewForHeaderInSection:(NSInteger)section;
-(void)DCFoldTable:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)DCtableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)DCFoldTable:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)DCtableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
@end


@interface DCFoldTableView : UITableView
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray* isFoldArray;
@property (nonatomic ,weak) id<DCFoldTableDelegate> dcdelegate;
@property (nonatomic ,weak) id<DCFoldTableDataSource> dcdataSource;

// 子类重写此方法可以定制除折叠按钮之外的SectionView样式。
- (UIView*)tableView:(UITableView*)tableView sectionViewInSection:(NSInteger)section;
//定于特定的焦点
-(void)showIndexPath:(NSIndexPath *)indexPath;

@end
