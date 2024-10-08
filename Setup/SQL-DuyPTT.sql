use DUYPTT_DATABASE
select *
from tb_UserAuthenAuthor

create table tb_User
(
	USERID VARCHAR(50),
	USERNAME VARCHAR(100),
	PASS VARCHAR(100),
	CREATEDATE DATETIME,
	UPDATEDATE DATETIME
)
--duyptt@123
--tanhptt@123
SELECT * FROM tb_User
delete from tb_User
insert into tb_User(USERID,USERNAME,PASS,CREATEDATE,UPDATEDATE) values('19951411','duyptt','092F08FD239C7EA71D3904686ACB701A',GETDATE(),GETDATE())
insert into tb_User(USERID,USERNAME,PASS,CREATEDATE,UPDATEDATE) values('19951511','tanhptt','57C094D4C5ED62E537BA2650D079682C',GETDATE(),GETDATE())
insert into tb_User(USERID,USERNAME,PASS,CREATEDATE,UPDATEDATE) values('19951611','heo','95C378CD297418F9A1F65BEB326B4DF1',GETDATE(),GETDATE())

GO

select CONVERT(VARCHAR(32), HashBytes('MD5', 'heo@123'), 2);

create table tb_RoleUser
(
	IDROLE INT IDENTITY(1,1),
	USERID VARCHAR(50),
	ROLENAME VARCHAR(50)
)
SELECT * FROM tb_RoleUser
INSERT INTO tb_RoleUser(USERID,ROLENAME) VALUES('19951411','READ')
INSERT INTO tb_RoleUser(USERID,ROLENAME) VALUES('19951411','WRITE')
INSERT INTO tb_RoleUser(USERID,ROLENAME) VALUES('19951511','READ')
INSERT INTO tb_RoleUser(USERID,ROLENAME) VALUES('19951611','WRITE')
go

alter procedure sp_GetUser
(
@username VARCHAR(100),
@pass VARCHAR(100)
)
as
begin
DECLARE @MD5PASS VARCHAR(32) = CONVERT(VARCHAR(32), HashBytes('MD5', @pass), 2);
	select top 1 USERID,USERNAME,CREATEDATE,UPDATEDATE
	from DUYPTT_DATABASE.dbo.tb_User
	where USERNAME=@username and PASS=@MD5PASS
end
go
create procedure sp_GetRoleUser
(
@userid VARCHAR(50)
)
as
begin
	select ROLENAME
	from DUYPTT_DATABASE.dbo.tb_RoleUser
	where USERID=@userid 
end
go

create procedure sp_GetUsername
(
@username VARCHAR(50)
)
as
begin
	select USERID,USERNAME,CREATEDATE,UPDATEDATE
	from DUYPTT_DATABASE.dbo.tb_User
	where USERNAME=@username 
end
go
alter procedure sp_InsertUser
(
@userid VARCHAR(50),
@username VARCHAR(50),
@pass varchar(50)
)
as
begin
DECLARE @MD5PASS VARCHAR(32) = CONVERT(VARCHAR(32), HashBytes('MD5', @pass), 2)

IF EXISTS (SELECT USERID FROM DUYPTT_DATABASE.dbo.tb_User WHERE USERID = @userid)
BEGIN
	SELECT 'exists' AS USERID,'exists' AS USERNAME
END
ELSE
BEGIN
	insert into DUYPTT_DATABASE.dbo.tb_User(USERID,USERNAME,PASS,CREATEDATE,UPDATEDATE) values(@userid,@username,@MD5PASS,GETDATE(),GETDATE())
	SELECT @userid AS USERID,@username AS USERNAME
END
	
end
go