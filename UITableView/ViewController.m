//
//  ViewController.m
//  Objective-C-UITableView
//
//  Created by WeiChaoW on 16/9/26.
//  Copyright © 2016年 WeiChaoW. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
//表格视图
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property (nonatomic, strong) NSArray *sectionTitleArray;//索引数据
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionTitleArray = [NSArray arrayWithObjects:@"1-10",@"11-20",@"21-30",@"31-40",@"41-50",@"51-60",@"61-70",@"71-80",@"81-90",@"91-100", nil];
    
    [self.myTableView reloadData];
}



#pragma mark - UITableViewDataSource
//返回表格视图应该显示的数据的段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

//返回表格视图上每段应该显示的数据的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArray[section] count];
}

//返回某行上应该显示的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //定义一个cell标示符，用以区分不同的cell
    static NSString *cellID=@"cell";
    
    //从cell复用池中拿到可用的cell
    /*
     我们为什么要实现单元格的复用机制？
     单元格每一个cell的生成都是要init alloc的，所以当我们滑动表格试图的时候会生成很多cell，无异于浪费了大量的内存
     单元格的复用机制原理
     一开始的时候我们创建了桌面最多能显示的单元格数，cell
     当我们向下滚动表格试图的时候，单元格上部的内容会消失，下部的内容会出现，这个时候我们将上部分消失的单元格赋给下部分出现的单元格
     因此我们就做到了只生成了屏幕范围可显示的单元格个数，就实现滑动表格试图时，以后不会再init alloc单元格cell了，从而实现了节省内存的原理
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //检测，拿到一个可用的cell
    if(cell ==nil)
    {
        //创建新的cell
        /*
         UITableViewCellStyleDefault,    // 左侧显示textLabel（不显示detailTextLabel），imageView可选（显示在最左边）
         UITableViewCellStyleValue1,        // 左侧显示textLabel、右侧显示detailTextLabel（默认蓝色），imageView可选（显示在最左边）
         UITableViewCellStyleValue2,        // 左侧依次显示textLabel(默认蓝色)和detailTextLabel，imageView可选（显示在最左边）
         UITableViewCellStyleSubtitle    // 左上方显示textLabel，左下方显示detailTextLabel（默认灰色）,imageView可选（显示在最左边）
         */
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    
    NSDictionary *dict = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    //cell上文本
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [dict objectForKey:@"title"];
    
    //cell上的子标题
    cell.detailTextLabel.text = [dict objectForKey:@"detail"];
    
    //cell上图片
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    
    return cell;
}

//设置分段的头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //如果是第0个分段
    if(!section){
        return @"第 0 段段头";
        
    }
    
    //否则,(即第一个分段)
    return @"第 1 段段头";
    
}

//设置分段脚标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if(!section){
        
        return @"第 0 段段尾";
    }
    return @"第 1 段段尾";
}

//右边索引字节数(如果不实现 就不显示右侧索引)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionTitleArray;
}

//点击右边的索引，调用该方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSString *key = [self.sectionTitleArray objectAtIndex:index];
    NSLog(@"sectionForSectionIndexTitle key=%@",key);
    if (key == UITableViewIndexSearch) {
        [self.myTableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    
    return index;
}

//让表格可以修改，滑动可以修改
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//执行删除或者插入
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger row = [indexPath row];
        [self.dataArray removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        /*
         UITableViewRowAnimationAutomatic
         UITableViewRowAnimationTop
         UITableViewRowAnimationBottom
         UITableViewRowAnimationLeft
         UITableViewRowAnimationRight
         UITableViewRowAnimationMiddle
         UITableViewRowAnimationFade
         UITableViewRowAnimationNone
         */
    }
    //插入
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        //我们实现的是在所选行的位置插入一行，因此直接使用了参数indexPath
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath,nil];
        //同样，将数据加到list中，用的row
        //        [self.dataArray insertObject:@"新添加的行" atIndex:indexPath.];
        [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    }
}

//开始移动row时执行
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [[self.dataArray objectAtIndex:sourceIndexPath.section] objectAtIndex:fromRow];
    [self.dataArray removeObjectAtIndex:fromRow];
    [self.dataArray insertObject:object atIndex:toRow];
    
}

//移动row时执行
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSLog(@"targetIndexPathForMoveFromRowAtIndexPath");
    //用于限制只在当前section下面才可以移动
    if(sourceIndexPath.section != proposedDestinationIndexPath.section){
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}





#pragma mark - UITableViewDelegate
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//返回每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
//返回每一段段头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
//返回每一段段尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}

//自定义头标题的view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    
    //如果分段为第0段
    if(!section){
        label.text = @"第0段的断头";
    }
    //如果分段为第一段
    else{
        label.text = @"第 1 段的断头";
        
    }
    
    //return的view会替换自带的头标题view
    //frame设置无效,位置是固定的,宽度固定和table一样,高度通过代理方法设置
    return label;
    
}

//自定义尾标题的view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    
    //如果分段为第0段
    if(!section){
        label.text = @"第0段的断尾";
    }
    //如果分段为第一段
    else{
        label.text = @"第 1 段的断尾";
    }
    
    return label;
    
}

//cell将要显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
//cell已经显示
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
    
}

//头View将要显示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    
}
//头View已经显示
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    
}


//尾View将要显示
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    
}
//尾View已经显示
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    
    
}

//UITableViewCell的附件属性
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        
        return UITableViewCellAccessoryCheckmark;
    }else
        
        return UITableViewCellAccessoryNone;
    
}

//点击了附加图标时执行
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"accessoryButtonTappedForRowWithIndexPath");
}

//是否将要点亮某一行
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//是否已经点亮某一行
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//不点量某一行
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//将要选中某一行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath;
}

//已经选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//将要反选某一行
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath;
    
}

//已经反选了某一行
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//返回删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}

// 8.0后侧滑菜单的新接口，支持多个侧滑按钮。
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"编辑", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 
             }],
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 
             }],[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"置顶", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 
             }]
             ];
}

//编辑模式下，让行缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//行缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger row = [indexPath row];
    return row;
}

//将要开始编辑某一行
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//结束编辑某一行
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//允许Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

//每个cell都可以点击出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    
    if (action == @selector(cut:)){
        
        
        return NO;
        
    }  else if(action == @selector(copy:)){
        
        
        return YES;
        
    }
    
    else if(action == @selector(paste:)){
        
        
        return NO;
        
    }
    
    else if(action == @selector(select:)){
        
        
        return NO;
        
    }
    
    else if(action == @selector(selectAll:)){
        
        
        return NO;
        
    }    else  {
        
        return [super canPerformAction:action withSender:sender];
        
    }
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    
    if (action ==@selector(copy:)) {
        
        //        [UIPasteboard  generalPasteboard].string = [array ValueobjectAtIndex:indexPath.row];
        
    }
    
    if (action ==@selector(cut:)) {
        
        //        [UIPasteboard  generalPasteboard].string = [arrayValueobjectAtIndex:indexPath.row];
        
        //        [arrayValue  replaceObjectAtIndex:indexPath.rowwithObject:@""];
        //
        //        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    if (action == @selector(paste:)) {
        
        //        NSString *pasteString = [UIPasteboard  generalPasteboard].string;
        //
        //        NSString *tmpString = [NSString  stringWithFormat:@"%@%@",[arrayValue  objectAtIndex:indexPath.row],pasteString];
        //
        //        [arrayValue   replaceObjectAtIndex:indexPath.rowwithObject:tmpString];
        //
        //        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

//焦点
- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
    
}






//懒加载
- (UITableView *)myTableView{
    
    //如果myTableView不存在
    if (_myTableView == nil) {
        
        //创建myTableView
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-64) style:UITableViewStylePlain];
        
        //myTableView的背景色
        _myTableView.backgroundColor = [UIColor redColor];
        
        //成为方法代理
        _myTableView.delegate = self;
        
        //成为数据源代理
        _myTableView.dataSource = self;
        
        //不显示垂直方向的进度条
        _myTableView.showsVerticalScrollIndicator = NO;
        
        //添加表格视图
        [self.view addSubview:self.myTableView];
        
        
    }
    
    //返回表格视图
    return _myTableView;
}

//懒加载创建数据源
- (NSMutableArray *)dataArray{
    
    //如果没有数据源
    if (!_dataArray) {
        
        //初始化数据源
        _dataArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *firstArray = [[NSMutableArray alloc] init];
        //用循环添加数据
        for (NSInteger i = 0; i < 10; i++) {
            
            //创建字典
            NSDictionary *dict = @{@"title":[NSString stringWithFormat:@"第 %zd 条数据的标题",i],@"detail":[NSString stringWithFormat:@"第 %zd 条数据的详情",i],@"image":[NSString stringWithFormat:@"image%zd",i]};
            
            //把创建好的字典添加
            [firstArray addObject:dict];
        }
        
        NSMutableArray *twoArray = [[NSMutableArray alloc] init];
        //用循环添加数据
        for (NSInteger i = 0; i < 10; i++) {
            
            //创建字典
            NSDictionary *dict = @{@"title":[NSString stringWithFormat:@"第 %zd 条数据的标题",i],@"detail":[NSString stringWithFormat:@"第 %zd 条数据的详情",i],@"image":[NSString stringWithFormat:@"image%zd",i]};
            
            //把创建好的字典添加
            [twoArray addObject:dict];
        }
        
        //添加数据源
        [_dataArray addObject: firstArray];
        [_dataArray addObject: twoArray];
    }
    
    //返回已经创建好的数据源
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
