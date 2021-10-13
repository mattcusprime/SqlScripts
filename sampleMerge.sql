MERGE INTO dbo.Organizations d
USING
(
                SELECT
                                aa.venCode
                                ,pay.payID AS [PayID]
                FROM dbo.aa_Import aa
                JOIN dbo.PaymentTerms pay ON aa.venCodeExt = pay.payCode
) s
                ON s.venCode = d.venCode
                AND s.payID = d.payID
WHEN MATCHED THEN UPDATE
                SET d.payID = s.payID;
