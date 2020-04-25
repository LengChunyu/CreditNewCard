//
//  AccountBookViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/6/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "AccountBookViewController.h"
#import "AccountBookTableViewCell.h"
#import "AddAccoutBookViewController.h"
#import "GestureViewController.h"
@interface AccountBookViewController ()<UITableViewDelegate,UITableViewDataSource,AddAccountBookDelegate,PasswordSetBack,JVAlertViewDelegate>
@property (nonatomic,strong) UITableView *bookTableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) AccountBookModel *selectModel;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,assign) int deleteIndex;
@property (nonatomic,assign) BOOL isDeleting;//是否正在进行删除操作
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,assign) BOOL isEdit;//是否处于编辑状态
@property (nonatomic,strong) NSMutableDictionary *statusMuDic;
@property (nonatomic,strong) UIView *operationView;
@end

@implementation AccountBookViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController isKindOfClass:[BBNavigationController class]]) {
        
        BBNavigationController *bbNavigation =(BBNavigationController *)self.navigationController;
        bbNavigation.panBeginBlock =nil;
        bbNavigation.panEndFailedBlock = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController isKindOfClass:[BBNavigationController class]]) {
        
        BBNavigationController *bbNavigation =(BBNavigationController *)self.navigationController;
        bbNavigation.panBeginBlock = ^{
            
            
            NSLog(@"scrollEnabled=====No");
            self.bookTableView.scrollEnabled =NO;
        };
        bbNavigation.panEndFailedBlock = ^{
            NSLog(@"scrollEnabled=====Yes");
            self.bookTableView.scrollEnabled =YES;
        };
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"账本";
    self.isDeleting =NO;
    self.isEdit =NO;
    self.view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.statusMuDic =[[NSMutableDictionary alloc]init];
    self.dataSourceArray =[[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    /*
     ,accountBookName TEXT,secretString TEXT,isConsume TEXT,isRepay TEXT,isSecret TEXT,isShowSwitch TEXT,time TEXT
     */
    AccountBookModel *model =[[AccountBookModel alloc] init];
    model.accountBookName =@"总账本";
    model.secretString =@"";
    model.isConsume =YES;
    model.isRepay =YES;
    model.isSecret =NO;
    model.isShowSwitch =YES;
    model.time =[dateFormatter stringFromDate:[NSDate date]];
    [self.dataSourceArray addObject:model];
    
    NSArray *accountArray =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
    if (accountArray.count>0) {
        
        [self.dataSourceArray addObjectsFromArray:accountArray];
    }
    for (int i=0;i<self.dataSourceArray.count; i++) {
        AccountBookModel *accountModel =self.dataSourceArray[i];
        if ([accountModel.accountBookName isEqualToString:self.titleString]) {
            
            self.selectIndex =i;
        }
    }
    [self creatTableView];
    [self creatNavigationItem];
}
-(void)creatTableView{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?84:64,self.view.width,0)];
    headView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:headView];
    
    self.bookTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,headView.bottom, self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64)) style:UITableViewStyleGrouped];
    self.bookTableView.delaysContentTouches =NO;
    self.bookTableView.delegate =self;
    self.bookTableView.dataSource =self;
    self.bookTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.bookTableView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.bookTableView.estimatedRowHeight = 0;
    self.bookTableView.estimatedSectionFooterHeight = 0;
    self.bookTableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.bookTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0) {
        
        self.bookTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.bookTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
-(void)creatNavigationItem{
    
    self.rightButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0,60,44)];
    [self.rightButton setTitle:@"合并" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(mergeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    self.operationView =[[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50,SCREEN_WIDTH, 50)];
    self.operationView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:self.operationView];
    
    UIButton *cancelButton =[[UIButton alloc]initWithFrame:CGRectMake(20,0,SCREEN_WIDTH/2-30,44)];
    cancelButton.layer.cornerRadius =5;
    cancelButton.clipsToBounds =YES;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor =[UIColor orangeColor];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:cancelButton];
    
    UIButton *sureButton =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10,0,SCREEN_WIDTH/2-30,44)];
    sureButton.layer.cornerRadius =5;
    sureButton.clipsToBounds =YES;
    [sureButton setTitle:@"合并" forState:UIControlStateNormal];
    sureButton.backgroundColor =[UIColor redColor];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(operationSureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:sureButton];
    self.operationView.hidden =YES;
}
-(void)mergeButtonClick:(UIButton *)button{
    
    button.selected =!button.selected;
    self.isEdit =button.selected;
    [self.statusMuDic removeAllObjects];
    [self.bookTableView reloadData];
    self.operationView.hidden =!button.selected;
}
-(void)cancelButtonClick:(UIButton *)button{
    
    self.rightButton.selected =NO;
    self.isEdit =NO;
    [self.statusMuDic removeAllObjects];
    [self.bookTableView reloadData];
    self.operationView.hidden =YES;
}
-(void)operationSureButtonClick:(UIButton *)button{
    //开始合并账本
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,0.0001)];
    view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,80)];
    view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake((self.view.width-200)/2,0,200,40)];
    button.backgroundColor =[UIColor whiteColor];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addAccountBookButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius =3.0;
    button.clipsToBounds =YES;
    [view addSubview:button];
    if (self.isEdit) {
        button.hidden =YES;
    }else{
        button.hidden =NO;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
       
        return 95;
    }else{
    
        return 70;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountBookTableViewCell *bookCell =[tableView dequeueReusableCellWithIdentifier:@"AccountBookTableViewCell"];
    if (bookCell == nil) {
        
        bookCell =[[AccountBookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountBookTableViewCell"];
    }
    bookCell.isEdit =self.isEdit;
    bookCell.selectIndex =self.selectIndex;
    bookCell.indexPath =indexPath;
    bookCell.selectionStyle =UITableViewCellSelectionStyleNone;
    AccountBookModel *bookModel =self.dataSourceArray[indexPath.row];
    bookCell.accountModel =bookModel;
    NSArray *keysArray =self.statusMuDic.allKeys;
    if ([keysArray containsObject:bookModel.accountBookName]) {
        
        bookCell.isSelect =YES;
    }else{
       
        bookCell.isSelect =NO;
    }
    
    return bookCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AccountBookModel *model =self.dataSourceArray[indexPath.row];
    if (self.isEdit) {
        
        if (indexPath.row!=0) {
            //单独刷新某一个cell
            if ([self.statusMuDic.allKeys containsObject:model.accountBookName]) {
                
                [self.statusMuDic removeObjectForKey:model.accountBookName];
            }else{
                
                [self.statusMuDic setObject:@(YES) forKey:model.accountBookName];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        
        self.selectModel =model;
        if (model.isSecret) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //弹出密码确认密码
                self.isDeleting =NO;
                GestureViewController *gestureVC =[[GestureViewController alloc] init];
                gestureVC.passWordDelegate =self;
                gestureVC.oldPassword =model.secretString;
                gestureVC.isChangePassWord =NO;
                gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:gestureVC animated:YES completion:nil];
            });
        }else{
            
            if (self.accountBackDelegate && [self.accountBackDelegate respondsToSelector:@selector(accoutBackSelectModel:withIsReload:)]) {
                
                [self.accountBackDelegate accoutBackSelectModel:model withIsReload:YES];
            }
            //记录下当前选中的账本名称
            [[NSUserDefaults standardUserDefaults]setObject:model.accountBookName forKey:@"selectAccountName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        return NO;
    }else{
        if (self.isEdit) {
            
            return NO;
        }
        return YES;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        AccountBookModel *model =self.dataSourceArray[indexPath.row];
        UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 10,280,100)];
        UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(30,(100-40)/2,220,40)];
        contentLabel.text =[NSString stringWithFormat:@"确定要删除\"%@\"此账本吗？",model.accountBookName];
        contentLabel.numberOfLines =0;
        contentLabel.font =[UIFont systemFontOfSize:14];
        contentLabel.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        [customView addSubview:contentLabel];
        self.deleteIndex =indexPath.row;
        //给报警音起个名
        JVAlertView *alertview=[[JVAlertView alloc]initWithCustomStyle:JVAlertViewStyleCustom headType:1 Title:@"提示" custom:customView delegate:self cancelTitle:@"取消" otherTitle:@"确定"];
        alertview.tag =20;
        [alertview show:self];
    }];
    rowAction.backgroundColor =UIColorFromRGB(0xff5f5f);
    return @[rowAction];
}
-(void)comeBackPasswordType:(int)passWordType withPassWord:(NSString *)passWordString{
    if(passWordType==0){
        //验证密码成功直接返回记账数据列表 需要提前有个回调
        if (self.isDeleting) {
        
            [self deleteAccountBookMethod];
            self.isDeleting =NO;
        }else{
           
            if (self.accountBackDelegate && [self.accountBackDelegate respondsToSelector:@selector(accoutBackSelectModel:withIsReload:)]) {
                
                [self.accountBackDelegate accoutBackSelectModel:self.selectModel withIsReload:YES];
            }
            //记录下当前选中的账本名称
            [[NSUserDefaults standardUserDefaults]setObject:self.selectModel.accountBookName forKey:@"selectAccountName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountBookTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backView.alpha =0.5f;
    return YES;
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountBookTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backView.alpha =1.0f;
}
-(void)addAccountBookButton:(UIButton *)button{

    AddAccoutBookViewController *addAccoutBookVC =[[AddAccoutBookViewController alloc]init];
    addAccoutBookVC.allAccountBookArray =self.dataSourceArray;
    addAccoutBookVC.callBackDelegate =self;
    [self.navigationController pushViewController:addAccoutBookVC animated:YES];
}
//添加账本的回调
-(void)addAccountBookFinishBack{
    
    NSArray *accountArray =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
    if (accountArray.count>0) {
        
        [self.dataSourceArray removeObjectsInRange:NSMakeRange(1,self.dataSourceArray.count-1)];
        [self.dataSourceArray addObjectsFromArray:accountArray];
    }
    [self.bookTableView reloadData];
}
- (void)alertView:(JVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
    }else{
        if (alertView.tag==20) {
            
            AccountBookModel *accountModel =self.dataSourceArray[self.deleteIndex];
            if (accountModel.isSecret) {
                //弹出密码确定后才能删除
                dispatch_async(dispatch_get_main_queue(), ^{
                    //弹出密码确认密码
                    self.isDeleting =YES;
                    GestureViewController *gestureVC =[[GestureViewController alloc] init];
                    gestureVC.passWordDelegate =self;
                    gestureVC.oldPassword =accountModel.secretString;
                    gestureVC.isChangePassWord =NO;
                    gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self presentViewController:gestureVC animated:YES completion:nil];
                });
            }else{
               
                [self deleteAccountBookMethod];
            }
        }
    }
}
-(void)deleteAccountBookMethod{
    
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    AccountBookModel *accountModel =self.dataSourceArray[self.deleteIndex];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[CardDataFMDB shareSqlite]delRecordFromAllAccountData:accountModel.accountBookName];
        [[CardDataFMDB shareSqlite]delAccountBookData:accountModel.accountBookName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSourceArray removeObjectAtIndex:self.deleteIndex];
            if (self.selectIndex==self.deleteIndex) {
                
                self.selectIndex =0;
                self.titleString =@"总账本";
            }else{
                for (int i=0;i<self.dataSourceArray.count;i++) {
                    AccountBookModel *model =self.dataSourceArray[i];
                    if ([model.accountBookName isEqualToString:self.titleString]) {
                        
                        self.selectIndex =i;
                    }
                }
            }
            [self.bookTableView reloadData];
            if (self.accountBackDelegate && [self.accountBackDelegate respondsToSelector:@selector(accoutBackSelectModel:withIsReload:)]) {
                
                [self.accountBackDelegate accoutBackSelectModel:self.dataSourceArray[self.selectIndex] withIsReload:NO];
            }
            [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];
            [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:@"删除成功"];
        });
    });
}
-(void)dealloc{

    NSLog(@"账本列表界面销毁了");
}
@end
