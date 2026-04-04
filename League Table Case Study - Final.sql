/*
League Table Case Study

Build the league table from the match in a few steps

Instructions at
https://zomalex.co.uk/datasets/football_match_dataset.html

*/

-- Each match proiduces two results,one for each team
-- Store these in a  #MatchResult temporray table

DROP TABLE IF EXISTS #MatchResult;

SELECT 
	m.Date
	,m.HomeTeam AS Team
    ,CASE m.FTR WHEN 'H' THEN 'W' WHEN 'D' THEN 'D' ELSE 'L' END AS Result
	,CASE 	WHEN m.FTHG > m.FTAG THEN 1 ELSE 0 	END AS Won
	,CASE WHEN m.FTHG = m.FTAG THEN 1 ELSE 0 END AS Drawn
	,CASE WHEN m.FTHG < m.FTAG THEN 1 ELSE 0 END AS Lost
	,m.FTHG AS [For]
	,m.FTAG AS [Against]
	,CASE m.FTR WHEN 'H' THEN 3 WHEN 'D' THEN 1 ELSE 0 END AS Points
INTO 
	#MatchResult
FROM
	dbo.FootballMatch m
UNION ALL	
SELECT
	m.Date
	,m.AwayTeam AS Team
	,CASE m.FTR WHEN 'H' THEN 'L' WHEN 'D' THEN 'D' ELSE 'W' END AS Result
	,CASE WHEN m.FTHG < m.FTAG THEN  1 ELSE 0 END AS Won
	,CASE WHEN m.FTHG = m.FTAG THEN  1 ELSE 0 END AS Drawn
	,CASE WHEN m.FTHG > m.FTAG THEN  1 ELSE 0 END AS Lost
	,m.FTAG AS [For]
	,m.FTHG AS [Against]
	,CASE m.FTR WHEN 'H' THEN 0 WHEN 'D' THEN 1 ELSE 3 END AS Points
FROM
	dbo.FootballMatch m

-- inspect  few rows of the #MatchResult table
SELECT
	TOP 10
	*
FROM
	#MatchResult;

DROP TABLE IF EXISTS #LeagueTable;

SELECT
	Team
	,COUNT(*) as Played
	,SUM(Won) AS Won
	,SUM(Drawn) AS Drawn
	,SUM(Lost) AS Lost
	,SUM([For]) AS [For]
	,SUM(Against) AS Against
	,SUM([For]) - SUM(Against) AS GD
	,SUM(Points) AS Points 
INTO
	#LeagueTable
FROM
	#MatchResult
GROUP BY
	Team;

SELECT
	Team
	,Played
	,Won
	,Drawn
	,Lost
	,[For]
	,Against
	,GD
	,Points
FROM
	#LeagueTable
ORDER BY
	Points DESC
	,GD DESC;


-- Add the Position column,with two implememtations: with and without Window Functions

SELECT
	(SELECT
		count(*) + 1
	FROM
		#LeagueTable sub
	WHERE (lt.Points < sub.Points) OR (lt.Points = sub.Points AND lt.GD < sub.GD) 
	) AS PositionNoWindowFunction
	,RANK() OVER (ORDER BY lt.Points DESC,lt.GD DESC) AS PositionUsingWindowFunction
	,lt.Team
	,lt.Played
	,lt.Won
	,lt.Drawn
	,lt.Lost
	,lt.[For]
	,lt.Against
	,lt.GD
	,lt.Points
FROM
	#LeagueTable lt
ORDER BY
	lt.Points DESC
	,lt.GD DESC;




-- add the Form,the team's results of the last five games

DROP TABLE IF EXISTS #MatchForm;

SELECT
	[Team]
	,[Date]
	,[Result]
	,ROW_NUMBER() OVER (PARTITION BY Team ORDER BY Team ,[Date] DESC) AS ReverseDateRank
INTO
	#MatchForm
FROM
	#MatchResult;

SELECT * FROM #MatchForm;

-- we only need the results from the last 5 matches
DELETE FROM #MatchForm WHERE ReverseDateRank > 5;  

SELECT
	*
FROM
	#MatchForm
ORDER BY Team,ReverseDateRank;

DROP TABLE IF EXISTS #MatchFormTranspose;

SELECT 
	Team 
	,CASE WHEN ReverseDateRank = 1 THEN Result ELSE NULL END AS R1
	,CASE WHEN ReverseDateRank = 2 THEN Result ELSE NULL END AS R2
	,CASE WHEN ReverseDateRank = 3 THEN Result ELSE NULL END AS R3
	,CASE WHEN ReverseDateRank = 4 THEN Result ELSE NULL END AS R4
	,CASE WHEN ReverseDateRank = 5 THEN Result ELSE NULL END AS R5
INTO #MatchFormTranspose
 FROM #MatchForm;

SELECT * FROM #MatchFormTranspose;

DROP TABLE IF EXISTS #MatchFormTransposeGroup;

SELECT 
	Team
	,MAX(R1) AS R1
	,MAX(R2) AS R2
	,MAX(R3) AS R3
	,MAX(R4) AS R4
	,MAX(R5) AS R5
	,MAX(R5) + MAX(R4) + MAX(R3) + MAX(R2) + MAX(R1) AS LatestMatchForm
INTO
	#MatchFormTransposeGroup
FROM
	#MatchFormTranspose
GROUP BY
	Team;

SELECT * FROM #MatchFormTransposeGroup;

SELECT
	lt.Team
	,lt.Won
	,lt.Drawn
	,lt.Lost
	,lt.[For]
	,lt.Against
	,(lt.[For] - lt.Against) AS GD
	,lt.Points
	,mftg.LatestMatchForm
FROM
	#LeagueTable lt INNER JOIN #MatchFormTransposeGroup mftg ON 	mftg.Team = lt.Team
ORDER BY
	lt.Points DESC
	,GD DESC;
