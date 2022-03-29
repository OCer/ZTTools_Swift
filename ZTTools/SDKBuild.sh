#!/bin/sh

#  SDKBuild.sh
#  ZTToolsSDK
#
#  Created by Asuna on 2022/3/4.
#  

CONFIG="${CONFIGURATION}" # "Release" "${CONFIGURATION}" "Debug" 编译模式，使用Release即可
SCHEME_NAME="${PROJECT_NAME}" # 要build的scheme名，如果和scheme名不一致，需要修改为正确的scheme名
OUTPUT_SDK="${SCHEME_NAME}" # 产物名字
OUTPUT_SDKNAME="${OUTPUT_SDK}.framework"

echo "Ztj 编译模式 = ${CONFIG}  编译的scheme = ${SCHEME_NAME}"
echo "Ztj 产物名字 = ${OUTPUT_SDKNAME}"

# 项目里存放Framework的路径
TARGET_FOLDER="${SRCROOT}/../ZTTools_Swift/Classes"
echo "Ztj 项目里存放Framework的路径 = ${TARGET_FOLDER}"

# 工作空间路径
WORK_FOLDER="${SRCROOT}/../Example/ZTTools_Swift.xcworkspace"
echo "Ztj 工作空间路径 = ${WORK_FOLDER}"

# ---------- 以上配置是可以修改的，下面的配置则不需要改 ----------

# 编译时存放xcarchive的路径
SIMULATOR_ARCHIVE_PATH="${SRCROOT}/build/${OUTPUT_SDK}-iphonesimulator.xcarchive"
DEVICE_ARCHIVE_PATH="${SRCROOT}/build/${OUTPUT_SDK}-iphoneos.xcarchive"
echo "Ztj 编译时存放xcarchive的路径  模拟器 = ${SIMULATOR_ARCHIVE_PATH}  真机 = ${DEVICE_ARCHIVE_PATH}"

# 编译时存放framework的路径
SIMULATOR_DIR_PATH="${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${OUTPUT_SDKNAME}"
DEVICE_DIR_PATH="${DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${OUTPUT_SDKNAME}"
echo "Ztj 编译时存放framework的路径  模拟器 = ${SIMULATOR_DIR_PATH}  真机 = ${DEVICE_DIR_PATH}"

# 定义函数，用来清除编译产生的文件
function removeBuild()
{
    echo "Ztj 判断build文件夹是否存在，存在则删除"
    # 判断build文件夹是否存在，存在则删除
    if [ -d "${SRCROOT}/build" ]
    then
    rm -rf "${SRCROOT}/build/"
    fi
}

# 删除编译之后生成的无关的配置文件
function removeBuildFile()
{
    echo "Ztj 删除编译之后生成的无关的配置文件 = ${1}"
    for FILE in $(ls "${1}"|tr " " "?") # 解决名字带空格的问题
    do
    if [[ "${FILE}" =~ ".xcconfig" ]]
    then
    rm -f "${1}/${FILE}"
    fi
    done
}

removeBuild # 编译前先删除之前留下来的，防止干扰

# 分别clean模拟器和真机
echo "Ztj 分别clean模拟器和真机"
xcodebuild clean -workspace "${WORK_FOLDER}" -scheme "${SCHEME_NAME}" -configuration "${CONFIG}" -derivedDataPath "./build" -archivePath "${DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
xcodebuild clean -workspace "${WORK_FOLDER}" -scheme "${SCHEME_NAME}" -configuration "${CONFIG}" -derivedDataPath "./build" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 编译真机的Framework
echo "Ztj 编译真机的Framework"
xcodebuild archive -workspace "${WORK_FOLDER}" -scheme "${SCHEME_NAME}" -configuration "${CONFIG}" -derivedDataPath "./build" -archivePath "${DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 编译模拟器的Framework
echo "Ztj 编译模拟器的Framework"
xcodebuild archive -workspace "${WORK_FOLDER}" -scheme "${SCHEME_NAME}" -configuration "${CONFIG}" -derivedDataPath "./build" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 当工作空间里的一个项目编译依赖于另一个项目 这不能用-target 只能用-workspace
# -workspace必须指定编译的-scheme
# -derivedDataPath指定编译build文件夹的路径；必须指定，不然编译完成后会报“disk I/O error”
# -archivePath指定编译build文件夹的路径 因为使用-workspace时，默认路径并不在当前目录，并且文件夹里的结构也改变了
# BUILD_LIBRARIES_FOR_DISTRIBUTION构建用于分发的库，也可以在Xcode里的Build libraries for Distribution设置；否则会报错“No ‘swiftinterface’ files found within xx.swiftmodule”的错

removeBuildFile "${DEVICE_DIR_PATH}"
removeBuildFile "${SIMULATOR_DIR_PATH}"

# 合并framework，创建xcframework
xcodebuild -create-xcframework \
-framework "${SIMULATOR_DIR_PATH}" \
-framework "${DEVICE_DIR_PATH}" \
-output "${TARGET_FOLDER}/${OUTPUT_SDK}.xcframework"

echo "Ztj 创建xcframework：  ${SIMULATOR_DIR_PATH} + ${DEVICE_DIR_PATH} --> ${TARGET_FOLDER}/${OUTPUT_SDK}.xcframework"

open "${TARGET_FOLDER}" # 打开文件夹

removeBuild
