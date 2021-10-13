

set nocount on
--DECLARE @ImosDbname nvarchar(30)=N'inSight_imos'
declare @username varchar(50)
declare @server nvarchar(20)
DECLARE @userID int

set @server = rtrim((select convert(char(20), SERVERPROPERTY('servername'))))


set @username = system_user

IF NOT EXISTS (select * from [dbo].[UserList] where usrlogin=@username)
    INSERT INTO [dbo].[UserList]( [usrName], [usrLogin])
    VALUES( @username, @username)

if not exists(select * from dbo.UserGroupUserList where usrId = (select usrID from dbo.UserList where usrLogin=@username) 
        and ugrId = (select ugrID from dbo.UserGroup where ugrName='Administrators'))
    insert into dbo.UserGroupUserList (usrId,ugrId)
 	select (select usrID from dbo.UserList where usrLogin=@username),(select ugrID from dbo.UserGroup where ugrName='Administrators')

SET @userID = (SELECT usrID FROM dbo.UserList WHERE usrLogin=@username)


if not exists(select * from 
inResponse.ServiceUsers--dbo.inResponseUsers
 where usrId = (select usrID from dbo.UserList where usrLogin=@username)) 
    insert into inResponse.ServiceUsers--dbo.inResponseUsers 
    (usrId)
	select (select usrID from dbo.UserList where usrLogin=@username)

INSERT INTO  inResponse.ServiceUserActionTypes -- dbo.inResponseUserActionTypes
(usrID
,acttID
,[Enabled])
SELECT  @userID, at.acttID, 1 
FROM inResponse.ActionTypes at
left join inResponse.ServiceUserActionTypes suat on suat.acttID = at.acttID and suat.usrID =@userID
WHERE (at.acttIDSystem IS NOT NULL) AND at.acttIDSystem 
in (4,9,13,14,15,16,17,25,26,28,32,35,41,44 )
--not in ( 1,2,5,7,8,11,12,18,20,21,22,30,31,33,34,37,38,40,42,43)---< 21) OR (at.acttIDSystem > 21)
and suat.acttID is null











