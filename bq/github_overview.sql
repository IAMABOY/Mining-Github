--使用bigquery-public-data:github_repos数据集
--该数据集的跟新较为频繁，数据较新
--比之使用githubarchive中的数据集要方便

--查询Github上总的仓库数量
--使用bigquery-public-data:github_repos.languages数据表

SELECT COUNT(*)
FROM [bigquery-public-data:github_repos.languages]

--3347497 repos by 2019 10/05


--查询Github上总commits数量
--使用bigquery-public-data:github_repos.commits数据表

SELECT COUNT(*)
FROM [bigquery-public-data:github_repos.commits]

-- 235186010 commits by 2019 10/05


--查询Github上总编程语言个数
--可以使用bigquery-public-data:github_repos.languages数据表
--注意的是结果中将Makefile,json,yaml等文件格式也标记成了编程语言

SELECT language.name,COUNT(*) counts
FROM [bigquery-public-data:github_repos.languages]
GROUP BY language.name
ORDER BY counts DESC;

-- 386 languages by 2019 10/05


--查询Github上license种类
--可以使用bigquery-public-data:github_repos.licenses数据表

SELECT license,COUNT(*) counts
FROM [bigquery-public-data:github_repos.licenses]
GROUP BY license
ORDER BY counts DESC;

-- 15 licenses by 2019 10/05


--查询github上有多少个独立的注册用户

SELECT COUNT(*)
FROM [ghtorrent-bq:ght_2018_04_01.users] 


--24154883 users by 2018 04/01