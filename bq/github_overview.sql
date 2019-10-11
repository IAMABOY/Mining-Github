--bq会用到三个关于Github数据集bigquery-public-data:github_repos,githubarchive,ghtorrent-bq
--bigquery-public-data:github_repos,githubarchive更新频繁，ghtorrent-bq好久没有更新，但是可以手动导入其官网数据
--三个数据集都有较为实用的信息，哪个方便使用哪一个



--查询Github上总的仓库数量
--使用bigquery-public-data:github_repos.languages数据表
--3347497 repos by 2019 10/05

SELECT COUNT(*)
FROM [bigquery-public-data:github_repos.languages]



--查询Github上总commits数量
--使用bigquery-public-data:github_repos.commits数据表
-- 235186010 commits by 2019 10/05

SELECT COUNT(*)
FROM [bigquery-public-data:github_repos.commits]


--查询Github上总编程语言个数
--可以使用bigquery-public-data:github_repos.languages数据表
--注意的是结果中将Makefile,json,yaml等文件格式也标记成了编程语言
-- 386 languages by 2019 10/05

SELECT language.name,COUNT(*) counts
FROM [bigquery-public-data:github_repos.languages]
GROUP BY language.name
ORDER BY counts DESC;


--查询Github上license种类
--可以使用bigquery-public-data:github_repos.licenses数据表
-- 15 licenses by 2019 10/05

SELECT license,COUNT(*) counts
FROM [bigquery-public-data:github_repos.licenses]
GROUP BY license
ORDER BY counts DESC;


--查询github上有多少个独立的注册用户
--24154883 users by 2018 04/01

SELECT COUNT(*)
FROM [ghtorrent-bq:ght_2018_04_01.users] 


--查询github上有多少个曾经提交记录的用户