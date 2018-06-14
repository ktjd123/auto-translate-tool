//
//  main.swift
//  auto-translate-tool
//
//  Created by 김성민 on 2018. 5. 29..
//  Copyright © 2018년 김성민. All rights reserved.
//

import Foundation

var jsFileName:[String] = []

let fileManager = FileManager()
let path="/Users/peter/Server/everesco/everesco-vn/frontend/src/"


do{
	let items = try fileManager.subpathsOfDirectory(atPath: path)
	for item in items{
		let newURL = URL(string: item)!
		let fileExtension = newURL.pathExtension
		if(fileExtension == "js"){
			jsFileName.append(path + newURL.relativePath)
		}
	}
	
}catch{
	print(error)
}

let translationFilePath = "/Users/peter/Desktop/everesco/base.txt"
let translationText:String
var translationKr: [String] = []
var translationEn: [String] = []

do{
	translationText = try String(contentsOfFile: translationFilePath, encoding: .utf8)
}
for i in translationText.components(separatedBy: "\n").reversed(){
	if i.lowercased().contains("ko: "){
		translationKr.append( String(i.dropFirst(4)))
	}
	if i.lowercased().contains("en: "){
		translationEn.append(String(i.dropFirst(4)))
	}
}

if(translationKr.count != translationEn.count){
	print(translationKr.count, translationEn.count)
	print("개수가 맞지 않습니다")
	exit(0)
}

var translationDic: [String: String] = [:]

for (i, item) in translationKr.enumerated(){
	translationDic[item] = translationEn[i]
}

let sortedTranslationDic = translationDic.sorted(by: { $0.key.count > $1.key.count })

// 무결성 검사
print("번역 무결성 검사를 시작합니다 총 개수: ", sortedTranslationDic.count)
print(sortedTranslationDic.count / 10, "번째 번역의 무결성 검사 \n \(sortedTranslationDic[sortedTranslationDic.count / 10].key)\n \(sortedTranslationDic[sortedTranslationDic.count / 10].value)\n (y, n)")
var validationString = readLine()!
if(validationString.lowercased() == "n"){
	exit(0)
}

print(sortedTranslationDic.count / 5, "번째 번역의 무결성 검사 \n \(sortedTranslationDic[sortedTranslationDic.count / 5].key)\n \(sortedTranslationDic[sortedTranslationDic.count / 5].value)\n (y, n)")
validationString = readLine()!
if(validationString.lowercased() == "n"){
	exit(0)
}

print(sortedTranslationDic.count / 3, "번째 번역의 무결성 검사 \n \(sortedTranslationDic[sortedTranslationDic.count / 3].key)\n \(sortedTranslationDic[sortedTranslationDic.count / 3].value)\n (y, n)")
validationString = readLine()!
if(validationString.lowercased() == "n"){
	exit(0)
}

print("마지막 번역 무결성 검사 \n \(sortedTranslationDic[sortedTranslationDic.count - 1].key)\n \(sortedTranslationDic[sortedTranslationDic.count - 1].value)\n (y, n)")
validationString = readLine()!
if(validationString.lowercased() == "n"){
	exit(0)
}

// 무결성 검사 끝

for item in jsFileName{
	do{
		var itemToReplace = try String(contentsOfFile: item, encoding: .utf8)
		
		for strings in sortedTranslationDic{
			if(strings.value == ""){
				print("WARNING - 번역 문자열이 존재하지 않습니다", strings.key, strings.value)
				continue
			}
			itemToReplace = itemToReplace.replacingOccurrences(of: strings.key, with: strings.value)
			print("translated")
		}
		
		try itemToReplace.write(toFile: item, atomically: false, encoding: .utf8)
		
	}
}
print()
print("번역되었습니다")
