DECLARE @olnID int = 6147
,@olnIDInstance smallint = 1



SELECT
ori.oriHID
,ori.oriHID.ToString() as oriHIDString
,ori.oriHID.GetLevel() as oriLevel
,ori.oriHID.GetAncestor(1).ToString() as oriHIDParent
,*
FROM dbo.OrderItems ori -- parent set
WHERE ori.oriIsShippable = 1
AND ori.olnID = @olnID
AND ori.olnIDInstance = @olnIDInstance



SELECT
ori.oriHID
,ori.oriHID.ToString() as oriHIDString
,ori.oriHID.GetLevel() as oriLevel
,ori.oriHID.GetAncestor(1).ToString() as oriHIDParent
--
,ori_child.*
FROM dbo.OrderItems ori -- parent set
OUTER APPLY
( -- child set for sub-report
SELECT
ori_child.oriHID.ToString() as oriHIDChild
,itm.itmItemNumber
FROM dbo.OrderItems ori_child
JOIN dbo.Items itm ON itm.itmID = ori_child.itmID
WHERE ori_child.olnID = ori.olnID
AND ori_child.olnIDInstance = ori.olnIDInstance
AND ori_child.oriHID.IsDescendantOf(ori.oriHID) = 1
--
AND ori_child.oriHID > ori.oriHID
) ori_child
WHERE ori.oriIsShippable = 1
AND ori.olnID = @olnID
AND ori.olnIDInstance = @olnIDInstance
AND ori.oriHID != hierarchyid::GetRoot()



SELECT
ori.oriHID
,ori.oriHID.ToString() as oriHIDString
,ori.oriHID.GetLevel() as oriLevel
,ori.oriHID.GetAncestor(1).ToString() as oriHIDParent
--
,ori_child.*
FROM dbo.OrderItems ori -- parent set
CROSS APPLY
( -- child set for sub-report
SELECT
ori_child.oriHID
,ori_child.oriHID.ToString() as oriHIDChild
,ori_child.oriHID.GetAncestor(1).ToString() as oriHIDParentChild
,itm.itmItemNumber
FROM dbo.OrderItems ori_child
JOIN dbo.Items itm ON itm.itmID = ori_child.itmID
WHERE ori_child.olnID = ori.olnID -- must be corellated to BOM instance
AND ori_child.olnIDInstance = ori.olnIDInstance -- must be corellated to BOM instance
AND ori_child.oriHID.IsDescendantOf(ori.oriHID) = 1 --
-- to exclude parent from child data set
AND ori_child.oriHID > ori.oriHID
) ori_child
WHERE ori.oriHID = '/4/'
AND ori.olnID = @olnID
AND ori.olnIDInstance = @olnIDInstance
AND ori.oriHID != hierarchyid::GetRoot() -- not a root item



ORDER BY ori_child.oriHID DESC




select hierarchyid::GetRoot() as rt
