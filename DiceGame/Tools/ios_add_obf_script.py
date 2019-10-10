# encoding: utf-8
'''
@author: wangjunpeng
@file: ios_add_obf_script.py
@time: 1/15/19 5:10 PM
@desc:
'''

import os, string, random, shutil, re

MY_CLASS_PREFIX_NAME = 'Game'

CURRENT_PATH = os.path.dirname(os.path.realpath(__file__)) + '/'
HEADER_SEACH_PATH = os.path.join(CURRENT_PATH, 'MyOne3-iOS-master')

randomStr = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

MY_FINAL_USE_CLASS_NAME = []

MY_FUNCTION_NAME_LIST = []
MY_CLASS_NAME_LIST = []

OUT_PUT_OC_FILE_FOLDER = os.path.join(CURRENT_PATH, "OCFiles")


def create_random_str(str_len):
    if str_len <= 0:
        print("Error , FunctionName or ClassName Len Less then 0")
        return
    tmp_str = '%s%s' % (random.choice(randomStr), ''.join(random.sample(string.ascii_letters + string.digits, str_len)))
    return tmp_str


def get_class_and_fun_name_list():
    list_dirs = os.walk(HEADER_SEACH_PATH)
    # 不区分大小写 pay 避免支付麻烦
    p = re.compile("pay", re.I)

    for root, dirs, files in list_dirs:
        for file in files:
            if file.endswith('.h'):
                header_file_path = os.path.join(root, file)
                with open(header_file_path) as f:
                    for line in f.readlines():
                        print("line--->",line)
                        if not re.search(p, line):
                            if '(void)' in line:
                                if ':' in line:
                                    my_main_fun = line.split(':')[0]
                                    idx = my_main_fun.find(')') + 1
                                    fun_name = my_main_fun[idx:].strip()
                                    fun_name = re.sub(u"([^\u4e00-\u9fa5\u0030-\u0039\u0041-\u005a\u0061-\u007a])", "",
                                                      fun_name)
                                    if fun_name not in MY_FUNCTION_NAME_LIST:
                                        MY_FUNCTION_NAME_LIST.append(fun_name)
                            if '@interface' in line:
                                if ':' in line and '//' not in line:
                                    my_class_str = line.split(':')[0]
                                    tmp_str = my_class_str.replace('@interface', '')
                                    class_name = tmp_str.strip()
                                    class_name = re.sub(u"([^\u4e00-\u9fa5\u0030-\u0039\u0041-\u005a\u0061-\u007a])",
                                                        "", class_name)
                                    if class_name not in MY_CLASS_NAME_LIST:
                                        MY_CLASS_NAME_LIST.append(class_name)


# 获取已知函数名字
def get_random_fun_name():
    list_len = len(MY_FUNCTION_NAME_LIST)
    random_idx = random.randint(0, list_len - 1)
    name = MY_FUNCTION_NAME_LIST[random_idx]
    return name


# 获取class name
def get_random_class_name():
    list_len = len(MY_CLASS_NAME_LIST)
    random_idx = random.randint(0, list_len - 1)
    name = MY_CLASS_NAME_LIST[random_idx]
    return name


# 写文件
def write_tmpstr_to_file(file_name, file_tempstr):
    full_file_path = os.path.join(OUT_PUT_OC_FILE_FOLDER, file_name)
    tmp_file = open(full_file_path, 'w')
    tmp_file.write(file_tempstr)
    tmp_file.close()


def create_header_file(class_name, function_list):
    class_prefix = MY_CLASS_PREFIX_NAME[:2]
    header_str = "@interface " + class_prefix + class_name + " : NSObject\r\n"
    file_name = MY_CLASS_PREFIX_NAME + '_' + class_name + ".h"

    start_symble = '+ '
    start_idx = 0

    for func in function_list:
        start_idx += 1
        if start_idx > 3:
            start_symble = '- '

        header_str += start_symble + '(void)' + func + ';\r\n'
    header_str += "@end\r\n"

    write_tmpstr_to_file(file_name, header_str)


def create_random_fun_content():
    tmp_str_content = ""
    random_choice_num = random.randint(1, 100)
    if random_choice_num > 50:
        tmp_var_name = []
        for i in range(random.randint(1, 5)):
            # 添加尾标防止重复
            tmp_var_name_v = create_random_str(3) + "_" + str(i)
            tmp_var_value_v = create_random_str(10)
            tmp_var_name.append(tmp_var_name_v)
            tmp_str_content += "  NSString *" + tmp_var_name_v + " = @\"" + tmp_var_value_v + "\";\r\n"
        exec_str = "  NSString * m_str = [[NSString alloc] initWithFormat:@\""
        tmp_at = ""
        tmp_v = ''
        for name in tmp_var_name:
            tmp_at += '%@'
            tmp_v += name + ','
        tmp_at += "\","
        tmp_v = tmp_v[:len(tmp_v) - 1]
        exec_str += tmp_at + tmp_v + '];\r\n'
        exec_str += '  NSLog(@"%@",m_str);\r\n'
        tmp_str_content += exec_str
    else:
        tmp_name_list = []
        for i in range(0, 2):
            rand_v = create_random_str(4) + "_" + str(i)
            tmp_name_list.append(rand_v)
            tmp_str_content += '  NSUInteger ' + str(rand_v) + " = " + str(random.randint(1, 100)) + ";\r\n"

        rand_v = create_random_str(4) + "_2"
        tmp_str_content += '  NSUInteger ' + str(rand_v) + " = 0;\r\n"
        tmp_str_content += "  if(" + tmp_name_list[0] + " >= " + tmp_name_list[1] + "){\r\n    "
        operat_list = [' + ', ' - ', ' * ', ' / ']
        tmp_str_content += str(rand_v) + " = " + tmp_name_list[0] + operat_list[random.randint(0, 3)] + tmp_name_list[
            0] + ";\r\n  }else{\r\n    "
        tmp_str_content += str(rand_v) + " = " + tmp_name_list[0] + operat_list[random.randint(0, 3)] + tmp_name_list[
            0] + ";\r\n  }\r\n"
    return tmp_str_content


def create_random_invoke_fun(func_left_list):
    tmp_str_content = "  [self "
    if len(func_left_list) <= 0:
        return ""
    random_idx = random.randint(0, len(func_left_list) - 1)
    random_fun_name = func_left_list[random_idx]
    tmp_str_content += random_fun_name + "];\r\n"
    return tmp_str_content


def create_condition_print_fun_str(func, random_str):
    tmp_str_content = ""
    tmp_name_list = []
    for i in range(2):
        # 添加尾标防止重复
        rand_v = create_random_str(6) + "_" + str(i)
        tmp_name_list.append(rand_v)
        tmp_str_content += '  NSUInteger ' + str(rand_v) + " = " + str(random.randint(1, 100)) + ";\r\n"

    rand_v = create_random_str(4) + "_2"
    tmp_str_content += '  NSUInteger ' + str(rand_v) + " = 0;\r\n"
    tmp_str_content += "  if(" + tmp_name_list[0] + " >= " + tmp_name_list[1] + "){\r\n    "
    operat_list = [' + ', ' - ', ' * ', ' / ']
    tmp_str_content += '  NSLog(@"' + func + random_str + '%d' + '",' + tmp_name_list[
        0] + ');' + "\r\n  }else{\r\n    "
    tmp_str_content += str(rand_v) + " = " + tmp_name_list[0] + operat_list[random.randint(0, 3)] + tmp_name_list[
        0] + ";\r\n  }\r\n"

    return tmp_str_content


def create_source_file(class_name, function_list):
    class_prefix = MY_CLASS_PREFIX_NAME[:2]
    source_str = "#include \"" + MY_CLASS_PREFIX_NAME + '_' + class_name + ".h\"\r\n" + "@implementation " + class_prefix + class_name + "\r\n"
    file_name = MY_CLASS_PREFIX_NAME + '_' + class_name + ".m"
    start_symble = '+ '
    start_idx = 0

    for func in function_list:
        start_idx += 1
        tmp_execute_str = create_random_fun_content()
        tmp_invoke_str = ""
        if start_idx > 3:
            start_symble = '- '
            tmp_invoke_str = create_random_invoke_fun(function_list[start_idx:])
        random_num = random.randint(3, 10)
        random_str = create_random_str(random_num)

        log_str = create_condition_print_fun_str(func, random_str)

        func_str = ""
        if random_num > 7:
            func_str = tmp_execute_str
        source_str += start_symble + '(void)' + func + '\n{ \n' + log_str + func_str + tmp_invoke_str + '} \n'
    source_str += "@end\r\n"
    write_tmpstr_to_file(file_name, source_str)


# 生成 头文件和 source file
def create_custom_classes(class_name):
    fun_num = random.randint(7, 20)
    tmp_fun_names = []
    for i in range(1, fun_num):
        tmp_str = get_random_fun_name()
        if tmp_str not in tmp_fun_names:
            tmp_fun_names.append(tmp_str)

    create_header_file(class_name, tmp_fun_names)
    create_source_file(class_name, tmp_fun_names)


# 生成 "OBCRegisterFile.mm"
def create_import_header_file():
    header_name = "OBCRegisterFile.mm"

    tmp_file_str = ""
    for name in MY_FINAL_USE_CLASS_NAME:
        header_file_name = MY_CLASS_PREFIX_NAME + '_' + name + ".h"
        tmp_file_str += "#include \"" + header_file_name + "\"\r\n"

    tmp_file_str += "void register_all_oc_files(){\r\n"
    for name in MY_FINAL_USE_CLASS_NAME:
        class_prefix = MY_CLASS_PREFIX_NAME[:2]
        class_name = class_prefix + name
        execute_str = "  " + class_name + "* m_" + class_name + " = [" + class_name + " new];\r\n"
        execute_str += "  [m_" + class_name + " release];\r\n"
        execute_str += "  m_" + class_name + " = nil;\r\n"
        tmp_file_str += execute_str

    tmp_file_str += "}\r\n"

    write_tmpstr_to_file(header_name, tmp_file_str)


if __name__ == '__main__':
    if os.path.isdir(OUT_PUT_OC_FILE_FOLDER):
        shutil.rmtree(OUT_PUT_OC_FILE_FOLDER)
    os.mkdir(OUT_PUT_OC_FILE_FOLDER)
    print("__main__--->")
    get_class_and_fun_name_list()

    useful_class_num = len(MY_CLASS_NAME_LIST)

    print("available class num is : " + str(useful_class_num))
    obc_class_num = int(input('Number of random ObjectC classes:'))

    if obc_class_num >= useful_class_num:
        obc_class_num = useful_class_num

    for i in range(0, obc_class_num):
        class_name = get_random_class_name()
        if class_name not in MY_FINAL_USE_CLASS_NAME:
            MY_FINAL_USE_CLASS_NAME.append(class_name)

    for name in MY_FINAL_USE_CLASS_NAME:
        create_custom_classes(name)
    create_import_header_file()
