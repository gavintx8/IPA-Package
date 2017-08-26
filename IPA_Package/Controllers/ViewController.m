//
//  ViewController.m
//  IPA_Package
//
//  Created by lxf on 2017/5/19.
//  Copyright © 2017年 lxf. All rights reserved.
//

#import "ViewController.h"
#import "NSDictionary+GetValue.h"
#import "AFNetworking.h"


#define kUrl @"http://www.pgyer.com/apiv1/app/viewGroup"
#define aid @"273f032c0777182b6297ad8e05d39d31"

@interface ViewController (){
    
    
    NSString *filepath;
    NSMutableDictionary *plistDic;
    NSMutableArray *projectNameArr;
    NSMutableArray *schemeNameArr;
    NSMutableArray *archiveArr;
    NSMutableArray *ipaPathArr;
    NSMutableArray *projectPathArr;
    NSMutableArray *uKeyArr;
    NSMutableArray *apiKeyArr;
    NSMutableArray *appIDArr;
    
    
    NSString *keyfilepath;
    NSMutableDictionary *keyPlistDic;
}

@property (nonatomic, strong) NSString *projectPath;

@property (nonatomic, strong) NSString *project_name;
@property (nonatomic, strong) NSString *scheme_name;
// 指定要打包编译的方式 Release,Debug..
@property (nonatomic, strong) NSString *build_configuration;

@property (nonatomic, strong) NSString *archivePath;

@property (nonatomic, strong) NSString *ipaPath;

@property (nonatomic, strong) NSString *plistPath;


@property (weak) IBOutlet NSComboBox *projectPathBox;
@property (weak) IBOutlet NSComboBox *projectNameTextBox;
@property (weak) IBOutlet NSComboBox *schemeNameTextBox;

@property (weak) IBOutlet NSComboBox *ipaPathText;
@property (weak) IBOutlet NSComboBox *uKeyBox;
@property (weak) IBOutlet NSComboBox *apiKeyBox;
@property (weak) IBOutlet NSComboBox *appID;

@property (weak) IBOutlet NSSegmentedControl *buildTypeSeg;
@property (weak) IBOutlet NSSegmentedControl *packageTypeSeg;
@property (weak) IBOutlet NSProgressIndicator *animator;


@property (weak) IBOutlet NSTextField *remindText;
@property (weak) IBOutlet NSTextField *downLoadUrlText;

@property (weak) IBOutlet NSButton *selectUploadBtn;

@property (weak) IBOutlet NSButton *getPackgeBtn;
@property (weak) IBOutlet NSButton *linkBtn;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSApplication sharedApplication].keyWindow setMinSize:NSMakeSize(532, 510)];
    self.title = @"打包工具";
    
    
    keyfilepath = [[NSBundle mainBundle]pathForResource:@"keyData.plist" ofType:nil];
    keyPlistDic = [NSMutableDictionary dictionaryWithContentsOfFile:keyfilepath];
    if (!keyPlistDic) {
        keyPlistDic = [NSMutableDictionary dictionary];
    }
    
    
    filepath = [[NSBundle mainBundle]pathForResource:@"data.plist" ofType:nil];
    plistDic = [NSMutableDictionary dictionary];
    projectNameArr = [NSMutableArray array];
    schemeNameArr = [NSMutableArray array];
    archiveArr = [NSMutableArray array];
    ipaPathArr = [NSMutableArray array];
    projectPathArr = [NSMutableArray array];
    
    plistDic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    
    projectNameArr = [plistDic objectForKey:@"project_name"];
    schemeNameArr = [plistDic objectForKey:@"scheme_name"];
    archiveArr = [plistDic objectForKey:@"archivePath"];
    ipaPathArr = [plistDic objectForKey:@"ipaPath"];
    projectPathArr = [plistDic objectForKey:@"projectPath"];
    uKeyArr = [plistDic objectForKey:@"ukey"];
    apiKeyArr = [plistDic objectForKey:@"apiKey"];
    appIDArr = [plistDic objectForKey:@"appID"];
    
    
    [self.projectNameTextBox addItemsWithObjectValues:projectNameArr];
    [self.schemeNameTextBox addItemsWithObjectValues:schemeNameArr];
//    [self.archivePathTextBox addItemsWithObjectValues:archiveArr];
    [self.ipaPathText addItemsWithObjectValues:ipaPathArr];
    [self.projectPathBox addItemsWithObjectValues:projectPathArr];
    [self.uKeyBox addItemsWithObjectValues:uKeyArr];
    [self.apiKeyBox addItemsWithObjectValues:apiKeyArr];
    [self.appID addItemsWithObjectValues:appIDArr];

    
    

    
}

/// 打包
- (IBAction)getPackage:(NSButton *)sender {
    
    //      ~/Desktop/IPA--Folder
    //      BKHousePet

    self.projectPath = self.projectPathBox.stringValue;
    
    self.project_name = self.projectNameTextBox.stringValue;
    self.scheme_name = self.schemeNameTextBox.stringValue;
    
//    self.archivePath = self.archivePathTextBox.stringValue;
    self.ipaPath = self.ipaPathText.stringValue;
    self.archivePath = self.ipaPathText.stringValue;

    
    
    if (self.buildTypeSeg.selectedSegment == 0) {
        self.build_configuration = @"Release";
    }else{
        self.build_configuration = @"Debug";
    }
    
    if (self.packageTypeSeg.selectedSegment == 0) {
        self.plistPath = [[NSBundle mainBundle]pathForResource:@"DevelopmentExportOptionsPlist.plist" ofType:nil];
    }else if (self.packageTypeSeg.selectedSegment == 1) {
        self.plistPath = [[NSBundle mainBundle]pathForResource:@"AdHocExportOptionsPlist.plist" ofType:nil];
    }else if (self.packageTypeSeg.selectedSegment == 2) {
        self.plistPath = [[NSBundle mainBundle]pathForResource:@"AppStoreExportOptionsPlist.plist" ofType:nil];
    }else if (self.packageTypeSeg.selectedSegment == 3) {
        self.plistPath = [[NSBundle mainBundle]pathForResource:@"EnterpriseExportOptionsPlist.plist" ofType:nil];
    }

    self.archivePath = [NSString stringWithFormat:@"%@/%@.xcarchive",self.ipaPath,self.project_name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *ipafilePathOld = [self.ipaPath.mutableCopy stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.project_name]];
    NSString *archivefilePathOld = [self.ipaPath.mutableCopy stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcarchive",self.project_name]];
    
    if([fileManager fileExistsAtPath:ipafilePathOld]) {
        [fileManager removeItemAtPath:ipafilePathOld error:nil];
    }
    if([fileManager fileExistsAtPath:archivefilePathOld]) {
        [fileManager removeItemAtPath:archivefilePathOld error:nil];
    }
    
    
    NSString *str1 = [NSString stringWithFormat:@"xcodebuild clean -workspace %@.xcworkspace -scheme %@ -configuration %@",self.project_name , self.scheme_name ,self.build_configuration];
    
    
    NSString *str2 = [NSString stringWithFormat:@"xcodebuild archive -workspace %@.xcworkspace -scheme %@ -configuration %@ -archivePath %@",self.project_name,self.scheme_name,self.build_configuration,self.archivePath];
    
    
    NSString *str3 = [NSString stringWithFormat:@"xcodebuild  -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist %@",self.archivePath,self.ipaPath,self.plistPath];
    
    
    NSString *tmp = [NSString stringWithFormat:@"cd %@\n%@\n%@\n%@\n",self.projectPath,str1,str2,str3];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        self.remindText.stringValue = @"正在打包...";
        sender.enabled = NO;
        [self.animator startAnimation:nil];
        self.animator.hidden = NO;
        
        system([tmp UTF8String]);
        [self.animator stopAnimation:nil];
        self.animator.hidden = YES;
        sender.enabled = YES;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *filePath = [self.ipaPath.mutableCopy stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.project_name]];
//
        if([fileManager fileExistsAtPath:filePath]) {
//            [self showAlertWithMessage:@"生成 ipa 文件成功!"""];
            self.remindText.stringValue = @"打包成功!";
            
        }else{
            self.remindText.stringValue = @"打包失败!";
//            [self showAlertWithMessage:@"生成 ipa 文件失败!"];
            
        }

        if (self.selectUploadBtn.state) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.remindText.stringValue = @"正在上传...";
                [self uploadAction:nil];
                
            });
        }
        

        
    });


     [self saveValueToPlist];
    
    
    
    
    
    
}



/// 上传到蒲公英
- (IBAction)uploadAction:(NSButton *)sender {
    
    self.projectPath = self.projectPathBox.stringValue;
    self.project_name = self.projectNameTextBox.stringValue;
    self.scheme_name = self.schemeNameTextBox.stringValue;
    self.ipaPath = self.ipaPathText.stringValue;
    self.archivePath = self.ipaPathText.stringValue;
    
    NSString *filePath = [self.ipaPath.mutableCopy stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.project_name]];
    
    NSData *contentData = [NSData data];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        contentData = [NSData dataWithContentsOfFile:filePath];;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param DWSetObject:self.apiKeyBox.stringValue forKey:@"_api_key"];
    [param DWSetObject:self.uKeyBox.stringValue forKey:@"uKey"];
    
    sender.enabled = NO;
    [[AFHTTPSessionManager manager]POST:@"https://qiniu-storage.pgyer.com/apiv1/app/upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:contentData name:@"file" fileName:[NSString stringWithFormat:@"%@.ipa",self.projectNameTextBox.stringValue] mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        CGFloat comple = uploadProgress.completedUnitCount;
        CGFloat total = uploadProgress.totalUnitCount;
        self.remindText.stringValue = [NSString stringWithFormat:@"正在上传 %.1f%%",comple/total*100];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[responseObject GetStringForKey:@"code"] isEqualToString:@"0"]) {
            self.remindText.stringValue = @"上传成功!";
        }else{
            self.remindText.stringValue = @"上传失败!";
            [self showAlertWithMessage:[responseObject GetStringForKey:@"message"]];
        }
        
        
        NSString *downLoadShortUrl = [[responseObject GetDictionaryForKey:@"data"] GetStringForKey:@"appShortcutUrl"];
        NSString *downloadUrl = [NSString stringWithFormat:@"https://www.pgyer.com/%@",downLoadShortUrl];
        self.downLoadUrlText.stringValue = downloadUrl;
        self.remindText.hidden = NO;
        self.downLoadUrlText.hidden = NO;
        self.linkBtn.hidden = NO;
        sender.enabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sender.enabled = YES;
        self.remindText.stringValue = @"上传失败!";
        [self showAlertWithMessage:[NSString stringWithFormat:@"%@",error]];
        
    }];
    [self saveValueToPlist];
}


/// 上传后获取 蒲公英当前 app 的信息
- (void)getInfo{
    
    NSDate *nowDate = [NSDate date];
    // 273f032c0777182b6297ad8e05d39d31
    NSURL *url = [NSURL URLWithString:kUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *param = [NSString stringWithFormat:@"_api_key=%@&aId=%@",self.apiKeyBox.stringValue,self.appID.stringValue];
    
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *datadic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (!datadic) {
            return ;
        }
        
        NSArray *arr = [datadic objectForKey:@"data"];
        
        if (!arr || arr.count ==0) {
            return;
        }
        
       
        NSDictionary *lastDic = [arr lastObject];
        NSString *lastUpdateTime = [lastDic objectForKey:@"appUpdated"];
        NSLog(@"%@",lastUpdateTime);
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *lastUpdate = [format dateFromString:lastUpdateTime];
        
        NSTimeInterval nowint = [nowDate timeIntervalSince1970]*1;
        NSTimeInterval lastUpdateInt = [lastUpdate timeIntervalSince1970]*1;
        NSTimeInterval value = nowint - lastUpdateInt;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [[NSAlert alloc]init];
            [alert setAlertStyle:NSAlertStyleWarning];
            if(value < 60) {
                NSLog(@"成功");
//                alert.messageText = @"上传成功!";
//                [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
//                    
//                    
//                }];
                
                self.remindText.stringValue = @"上传成功!";
                
            }else{
                self.remindText.stringValue = @"上传失败!";
//                alert.messageText = @"上传失败!";
//                [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
//                    
//                }];
            }
            
            
            
        });
        
        NSString *downLoadShortUrl = [lastDic objectForKey:@"appShortcutUrl"];
        NSString *downloadUrl = [NSString stringWithFormat:@"https://www.pgyer.com/%@",downLoadShortUrl];
        self.downLoadUrlText.stringValue = downloadUrl;
        self.remindText.hidden = NO;
        self.downLoadUrlText.hidden = NO;
        
    }];
    [task resume];
    
    
    [self saveValueToPlist];
    
    
    
}
- (IBAction)selectTextAction:(NSComboBox *)sender {
    
    

    NSDictionary *dic =[keyPlistDic GetDictionaryForKey:sender.stringValue];
    
    if (dic.allKeys.count == 0) {
        return;
    }
    
    self.projectPathBox.stringValue = [self.projectPathBox.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"projectPath"] :self.projectPathBox.stringValue;

    
    
    self.schemeNameTextBox.stringValue = [self.schemeNameTextBox.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"scheme_name"] :self.schemeNameTextBox.stringValue;
    
    
    self.ipaPathText.stringValue = [self.ipaPathText.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"ipaPath"] :self.ipaPathText.stringValue;
    
    self.uKeyBox.stringValue = [self.uKeyBox.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"uKey"] :self.uKeyBox.stringValue;
    self.apiKeyBox.stringValue = [self.apiKeyBox.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"apiKey"] :self.apiKeyBox.stringValue;
    self.appID.stringValue = [self.appID.stringValue isEqualToString:@""] ? [dic GetStringForKey:@"appID"] :self.appID.stringValue;

    
    
}

- (void)saveValueToPlist {
    
    if (![projectNameArr containsObject:self.project_name] && ![self.project_name isEqualToString:@""] && self.project_name) {
        [projectNameArr addObject:self.project_name];
    }
    
    if (![schemeNameArr containsObject:self.scheme_name] && ![self.scheme_name isEqualToString:@""] && self.scheme_name) {
        [schemeNameArr addObject:self.scheme_name];
    }
    
    //    if (![archiveArr containsObject:self.archivePathTextBox.stringValue] && ![self.archivePathTextBox.stringValue isEqualToString:@""] ) {
    //        [archiveArr addObject:self.archivePathTextBox.stringValue];
    //    }
    
    if (![ipaPathArr containsObject:self.ipaPath] && ![self.ipaPath isEqualToString:@""]&&self.ipaPath ) {
        [ipaPathArr addObject:self.ipaPath];
    }
    
    if (![projectPathArr containsObject:self.projectPath] && ![self.projectPath isEqualToString:@""] &&self.projectPath) {
        [projectPathArr addObject:self.projectPath];
    }

    
    if (![uKeyArr containsObject:self.uKeyBox.stringValue] && ![self.uKeyBox.stringValue isEqualToString:@""] &&(self.uKeyBox.stringValue)) {
        [uKeyArr addObject:self.uKeyBox.stringValue];
    }
    if (![apiKeyArr containsObject:self.apiKeyBox.stringValue] && ![self.apiKeyBox.stringValue isEqualToString:@""]  && (self.apiKeyBox.stringValue)) {
        [apiKeyArr addObject:self.apiKeyBox.stringValue];
    }
    if (![appIDArr containsObject:self.appID.stringValue] && ![self.appID.stringValue isEqualToString:@""] && (self.appID.stringValue)) {
        [appIDArr addObject:self.appID.stringValue];
    }
    
    
    [plistDic writeToFile:filepath atomically:YES];

    
    
    NSMutableDictionary *dic = [keyPlistDic GetDictionaryForKey:self.project_name].mutableCopy;
    if (![self.project_name isEqualToString:@""] && self.project_name) {
        [dic DWSetObject:self.project_name forKey:@"project_name"];
        
    }
    
    if (![self.scheme_name isEqualToString:@""] && self.scheme_name) {
        [dic DWSetObject:self.scheme_name forKey:@"scheme_name"];
    }
    
    //    if (![archiveArr containsObject:self.archivePathTextBox.stringValue] && ![self.archivePathTextBox.stringValue isEqualToString:@""] ) {
    //        [archiveArr addObject:self.archivePathTextBox.stringValue];
    //    }
    
    if (![self.ipaPath isEqualToString:@""]&&self.ipaPath ) {
        [dic DWSetObject:self.ipaPath forKey:@"ipaPath"];
    }
    
    if (![self.projectPath isEqualToString:@""] &&self.projectPath) {
        [dic DWSetObject:self.projectPath forKey:@"projectPath"];
    }
    
    
    if (![self.uKeyBox.stringValue isEqualToString:@""] &&(self.uKeyBox.stringValue)) {

        [dic DWSetObject:self.uKeyBox.stringValue forKey:@"uKey"];
    }
    if (![self.apiKeyBox.stringValue isEqualToString:@""]  && (self.apiKeyBox.stringValue)) {
       
        [dic DWSetObject:self.apiKeyBox.stringValue forKey:@"apiKey"];
    }
    if (![self.appID.stringValue isEqualToString:@""] && (self.appID.stringValue)) {
        
        [dic DWSetObject:self.appID.stringValue forKey:@"appID"];
    }

    if (self.project_name) {
        [keyPlistDic DWSetObject:dic forKey:self.project_name];
        
        [keyPlistDic writeToFile:keyfilepath atomically:YES];
    }

}

- (IBAction)linkAction:(id)sender {
    if (![self.downLoadUrlText.stringValue isEqualToString:@""]) {
        [[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:self.downLoadUrlText.stringValue]];
    }
    
    
    
}

- (IBAction)buildTypeSeg:(NSSegmentedControl *)sender {
    
    
    
}
- (IBAction)packageSegAction:(NSSegmentedControl *)sender {
    
}
- (IBAction)selectUpload:(NSButton *)sender {
//    sender.state = 0;
    if (sender.state) {
        self.getPackgeBtn.title = @"打包+上传";
    }else{
        self.getPackgeBtn.title = @"打包";
    }
    
    
    
}


- (void)showAlertWithMessage:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setAlertStyle:NSAlertStyleWarning];
        
        alert.messageText = msg;
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
            
            
        }];
    });
}



- (void)uploadWithCurl{
    self.projectPath = self.projectPathBox.stringValue;
    self.project_name = self.projectNameTextBox.stringValue;
    self.scheme_name = self.schemeNameTextBox.stringValue;
    self.ipaPath = self.ipaPathText.stringValue;
    self.archivePath = self.ipaPathText.stringValue;
    
    
    NSString *filePath = [self.ipaPath.mutableCopy stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.project_name]];
    //    8c61cb937fa1ce502d7292b225aa31ba  8977e1ba4b2cc950f94ad175086cb75d
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *cmdStr = [NSString stringWithFormat:@"curl -F \"file=@%@\" -F \"uKey=%@\" -F \"_api_key=%@\" https://qiniu-storage.pgyer.com/apiv1/app/upload",filePath,self.uKeyBox.stringValue,self.apiKeyBox.stringValue];
        
        
        [self.animator startAnimation:nil];
        self.animator.hidden = NO;
        
        system([cmdStr UTF8String]);
        [self.animator stopAnimation:nil];
        self.animator.hidden = YES;
        
        [self getInfo];
        
    });
}



- (void)upload{
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://qiniu-storage.pgyer.com/apiv1/app/upload"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求头数据 。  boundary：边界
    [request setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryftnnT7s3iF7wV5q6" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    [request setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", @"file", @"BKHousePet1111.ipa"] forHTTPHeaderField:@"Content-Disposition"];
    // 给请求头加入固定格式数据
    NSMutableData *data = [NSMutableData data];
    /****************文件参数相关设置*********************/
    // 设置边界 注：必须和请求头数据设置的边界 一样， 前面多两个“-”；（字符串 转 data 数据）
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置传入数据的基本属性， 包括有 传入方式 data ，传入的类型（名称） ，传入的文件名， 。
    [data appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"BKHousePet.ipa\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置 内容的类型  “文件类型/扩展名” MIME中的
    [data appendData:[@"Content-Type: application/octet-stream" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 加入数据内容
    NSData *contentData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"/Users/lxf/Desktop/IPA--Folder/BKHousePet.ipa"]];;
    [data appendData:contentData];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置边界
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************非文件参数相关设置**********************/
    //  设置传入的类型（名称）
    
    [data appendData:[@"Content-Disposition: form-data; name=\"_api_key\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 传入的名称username = lxl
    [data appendData:[@"8977e1ba4b2cc950f94ad175086cb75d" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 退出边界
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************非文件参数相关设置**********************/
    //  设置传入的类型（名称）
    [data appendData:[@"Content-Disposition: form-data; name=\"uKey\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // 传入的名称username = lxl
    [data appendData:[@"8c61cb937fa1ce502d7292b225aa31ba" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //
    

    // 退出边界
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
//    [data appendData:contentData];

//    NSString *paramStr = @"uKey=8c61cb937fa1ce502d7292b225aa31ba&_api_key=8977e1ba4b2cc950f94ad175086cb75d";
//    [data appendData:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
//    
    
    
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    [task resume];


}

- (NSString *)cmd:(NSString *)cmd
{
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/Applications/XAMPP/xamppfiles/bin/curl"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    // 开始task
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    // 获取运行结果
    NSData *data = [file readDataToEndOfFile];
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSString *)mimeTypeForFileAtPath:(NSString *)path{
    
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        
        return nil;
        
    }
    
    
    
    CFStringRef UTI =
    
    UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                          
                                          (__bridge CFStringRef)[path pathExtension], NULL);
    
    
    
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI,
                                                            
                                                            kUTTagClassMIMEType);
    
    
    
    CFRelease(UTI);
    
    
    
    if (!MIMEType) {
        
        return @"application/octet-stream";
        
    }
    
    return (__bridge NSString *)MIMEType;
    
}
@end
