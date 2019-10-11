import sys
import os
import json
import gzip

def jsonReader(inputJsonFilePath,pos):

    flag = False
    with gzip.open(inputJsonFilePath, 'r') as jsonContent:
        for rowNumber, line in enumerate(jsonContent, start=1):
            try:

                #此处加上flag的目的在于，当程序挂掉时候，可以根据域名从指定位置开始，不必重头开始跑
                if rowNumber == pos:
                    flag = True

                if not flag:
                    continue

                line = line.strip()
                if len(line) <= 0:
                    continue

                jsonObject = json.loads(line)

                repoInfo = jsonObject.get('repo',None)
                
                
                if repoInfo == '' or repoInfo == None:
                    continue

                print(repoInfo)
            except Exception as e:
                print(e)

if __name__ == '__main__':

    jsonReader('2019-09-19-10.json.gz',1)