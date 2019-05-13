

CREATE FUNCTION DEVOPS.[fn_SplitString](
 @String varchar (max),
 @Delimiter varchar (10)
 )
returns @ValueTable table ([Value] varchar(max))
begin
 declare @NextString varchar(max)
 declare @Pos int
 declare @NextPos int
 declare @CommaCheck varchar(1)
 if (@String IS NULL) OR (@Delimiter IS NULL) OR (rtrim(@String) = '')
BEGIN
 insert into @ValueTable ( [Value]) Values (@String)
return 
END
 
 --Initialize
 set @NextString = ''
 set @CommaCheck = right(@String,1) 
 
 --Check for trailing Comma, if not exists, INSERT
 --if (@CommaCheck <> @Delimiter )
 set @String = @String + @Delimiter
 
 --Get position of first Comma
 set @Pos = charindex(@Delimiter,@String)
 set @NextPos = 1
 
 --Loop while there is still a comma in the String of levels
 while (@pos <>  0)  
 begin
  set @NextString = substring(@String,1,@Pos - 1)
 
  insert into @ValueTable ( [Value]) Values (@NextString)
 
  set @String = substring(@String,@pos +1,len(@String))
  
  set @NextPos = @Pos
  set @pos  = charindex(@Delimiter,@String)
 end
 
 return
end