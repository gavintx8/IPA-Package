# 打包上传工具 (mac 工具)

###软件界面:
![Markdown preferences pane](https://github.com/xrefLee/IPA-Package/blob/master/111.png?raw=true)
###使用介绍:
参数名称   	          |介绍    				| 
--------------------|-------------------|
project_name        | 	.xcodeproj/.xcworkspace 的前缀  | 
项目文件夹路径  		| 	.xcodeproj/.xcworkspace 所在的文件夹   | 
scheme_name  			| 	项目名称(一般与 project_name 相同)      | 
包生成路径      		|  	ipa 包生成后存储的文件夹  | 
 uKey           		|  	上传蒲公英是需要的参数(在蒲公英账户中获取)   |
\_api\_key         	| 	上传蒲公英是需要的参数(在蒲公英账户中获取)     |

###打包逻辑:
在 `项目文件路径` 中找到以 `project_name` 为前缀的.xcodeproj/.xcworkspace 构建 以 `project_name` 命名的ipa 文件至 `包生成路径`

###上传逻辑:
1. 在 `包生成路径` 找到以 `project_name` 命名的 ipa 文件; 
2. 根据 `uKey` 和 `\_api\_key` 上传至蒲公英

