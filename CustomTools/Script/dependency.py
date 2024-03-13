# !/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import re
import argparse

# 常用的系统框架 不放在denpency中
ios_system_module = ['Foundation', 'UIKit', 'AppKit', 'CoreTelephony', 'Security', 'CoreFoundation', 'CoreMedia', 'CoreGraphics','MobileCoreServices', 'EventKit', 'Intents', 'LocalAuthentication', 'MediaPlayer',
                     'Accelerate', 'AssetsLibrary', 'SystemConfiguration', 'AdSupport', 'Contacts', 'CoreLocation', 'CoreMotion', 'CoreText', 'CommonCrypto', 'AppTrackingTransparency',
                     'Photos', 'QuartzCore', 'StoreKit', 'Speech', 'UserNotifications', 'WebKit', 'ImageIO', 'AudioToolbox', 'AVFoundation', 'CallKit',
                     'objc','arpa', 'libkern', 'mach', 'net', 'sys']

# 格式化输出对应颜色字体
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    RESET = '\033[0m'


def is_import_line(line):
        # 如果是 // 开头的是注释掉的 直接跳过
        if line.startswith('//'):
            return False
        
        return line.find('#import') != -1


def header_in_line(line):
        line = line.replace(" ","")
        if '/' in line and '<' in line:
            split_array = line.split('/')
            import_a = split_array[0]
            con_arr =  import_a.split('<')
            if con_arr:
                return con_arr[1]



def chang_podspace(pod_data):
    podspec_path = pod_data[0]
    components_name = pod_data[1]
    
    print(Colors.BLUE + "依赖的组件:" + ", ".join(components_name) + Colors.RESET)

    bk_space = podspec_path + '.bk'
    os.rename(podspec_path, bk_space)
    with open(bk_space, 'r') as pf:
        out_f = open(podspec_path, 'w')
        for line in pf.readlines():
            if "s.dependency" in line:
                out_f.write('')
            else:
                # podfine中可能有多个end，最后一个end 按照格式肯定在开头，出现多个end 前面有空格的不进行处理
                if  line.startswith('end'):
                    for i, val in enumerate(components_name):
                        out_f.write("  s.dependency '%s' \n" %val)
                        if i == len(components_name) - 1 :
                            out_f.write('end')
                else:
                    out_f.write(line)
        out_f.close()
    os.remove(bk_space)


def modify_component_header(componentsPath):

    all_files_path = []
    all_components = []
    podspace_path = ''
    # 输出所有文件和文件夹
    for (root, dirs, files) in os.walk(componentsPath):
        for name in files:
            if name.endswith('.podspec'):
                file_path = os.path.join(root,name)
                podspace_path = file_path

            if name.endswith('.h') or name.endswith('.m'):
                file_path = os.path.join(root,name)
                if 'Example' in file_path:
                    continue

                # 配置路径参数
                all_files_path.append(file_path)

    for filePath in all_files_path:
        for line in open(filePath,'r').readlines():
            if is_import_line(line):
                header = header_in_line(line)
                if header not in all_components and header not in ios_system_module and  isinstance(header, str):
                    all_components.append(header)
    # print('=======组件中依赖的所有其他组件%s' %(all_components))
    components_name = sorted(all_components)
    return (podspace_path,components_name)


#设置参数运行
parser = argparse.ArgumentParser(description="参数说明")
parser.add_argument('--filePath', '-f', help='依赖组件路径 必要参数', required=True)
args = parser.parse_args()



if __name__ == '__main__':
    # 当前参数路径
    current_path = args.filePath

    # 遍历传入路径中的所有文件夹
    folders = [f for f in os.listdir(current_path) if os.path.isdir(os.path.join(current_path,f))]

    for folder in folders:
        print(Colors.GREEN + "组件:" + folder + Colors.RESET)
        component_path = os.path.join(current_path,folder)
        pod_data = modify_component_header(component_path)
        # 修改podspec 文件
        chang_podspace(pod_data)
        print(Colors.GREEN + "组件:" + folder + "依赖配置完成" + "\n\n" + Colors.RESET)

       
