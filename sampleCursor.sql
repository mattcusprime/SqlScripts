DECLARE
       @cursItmNumber nvarchar(max);

DECLARE C CURSOR FAST_FORWARD --read only, forward only
       FOR select itmItemNumber from dbo.items where itmID = 92153;


OPEN C;
FETCH NEXT FROM C INTO @cursItmNumber;

WHILE @@FETCH_STATUS = 0
       BEGIN
              
              Print @cursItmNumber;
              FETCH NEXT FROM C INTO @cursItmNumber;
       END
CLOSE C;

DEALLOCATE C;
