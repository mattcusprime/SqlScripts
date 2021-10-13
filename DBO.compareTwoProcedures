CREATE OR ALTER PROCEDURE DBO.compareTwoProcedures
@procedure1name nvarchar(max)
,@procedure2name nvarchar(max)
AS



WITH table1 ([Schema],[name],[paramid],[paramname],[paramdatatype],[Explanation])
as(
SELECT
SCHEMA_NAME(SCHEMA_ID) AS [Schema]
,SO.name AS [ObjectName]
--,SO.Type_Desc AS [ObjectType (UDF/SP)]
,P.parameter_id AS [ParameterID]
,P.name AS [ParameterName]
,TYPE_NAME(P.user_type_id) AS [ParameterDataType]
,concat(N'This parameter is not found in ',@procedure2name) as [Explanation]
--,P.max_length AS [ParameterMaxBytes]
--,P.is_output AS [IsOutPutParameter]
FROM sys.objects AS SO
INNER JOIN sys.parameters AS P ON SO.OBJECT_ID = P.OBJECT_ID
where so.name = @procedure1name
--ORDER BY [Schema], SO.name
)
,table2 ([Schema],[name],[paramid],[paramname],[paramdatatype],[Explanation])
as(
SELECT
SCHEMA_NAME(SCHEMA_ID) AS [Schema]
,SO.name AS [ObjectName]
--,SO.Type_Desc AS [ObjectType (UDF/SP)]
,P.parameter_id AS [ParameterID]
,P.name AS [ParameterName]
,TYPE_NAME(P.user_type_id) AS [ParameterDataType]
,concat(N'This parameter is not found in ',@procedure1name) as [Explanation]
--,P.max_length AS [ParameterMaxBytes]
--,P.is_output AS [IsOutPutParameter]
FROM sys.objects AS SO
INNER JOIN sys.parameters AS P ON SO.OBJECT_ID = P.OBJECT_ID
where so.name = @procedure2name
--ORDER BY [Schema], SO.name
)



select * from table1
where paramname not in (select distinct paramname from table2)
union all
select * from table2
where paramname not in (select distinct paramname from table1)
