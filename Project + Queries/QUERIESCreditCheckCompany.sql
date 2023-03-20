#ProjectQueries

#Normal Queries (4)
#1
SELECT *
FROM SalesOrder
WHERE Odateissued BETWEEN '2020-01-01' AND '2020-08-31';

#2
SELECT *
FROM BlockReason
WHERE Rmotivation NOT IN ('sales order blocking reason', 'payment not received');

#3
SELECT *
FROM CreditGroup
WHERE Gexpertise = 'new group' AND Gworkgrade = 'A';

#4
SELECT *
FROM Delivery
WHERE Dtypes <> 'outbound delivery'
ORDER BY Dtypes;

#Join Queries (4)
#1
SELECT Sformat, document_id
FROM SalesDocument AS sd
INNER JOIN CreditLimitCheckParameter AS cl ON (sd.CRELIM_id = cl.PARAMETER_id)
WHERE Pchecktype IN ('no check', 'soft check');

#2
SELECT Sformat, document_id
FROM SalesDocument AS sd
INNER JOIN Billing AS b ON (sd.BIL_id = b.BILLING_id)
WHERE Btypes NOT IN ('past due invoice', 'pro forma invoice');

#3
SELECT Btypes
FROM Billing AS b
INNER JOIN SalesDocument AS sd ON (b.BILLING_id = sd.BIL_id)
INNER JOIN Delivery AS d ON (sd.DEL_id = DELIVERY_id)
WHERE Sformat = 'Physical'
ORDER BY Sformat;

#4
SELECT Essn AS 'Manager ID', CONCAT(Ename, ' ', Esurname) AS 'Group Manager'
FROM EmployeeGManager AS e
INNER JOIN CreditGroup AS cg ON (e.essn = cg.EMssn)
INNER JOIN SalesDocument AS sd ON (sd.GRO_id = cg.GROUP_id)
INNER JOIN BlockReason AS bl ON (sd.BLO_id = bl.Rblocknumber)
WHERE Rmotivation = 'not enough credit';

#Nested Queries (4) 
#1########################################################################
SELECT Gworkgrade AS 'Work Grade'
FROM CreditGroup
WHERE EMssn IN (SELECT Essn
			   FROM EmployeeGManager
			   WHERE Eaddress IN ('1242 Scofield Circle', '626 Truax Road', '5 Fordem Plaza'));
               
#2########################################################################
SELECT Ctcode, complaint_id
FROM Complaint
WHERE complaint_id IN (SELECT DOCUMENT_id
                       FROM SalesDocument
					   WHERE Sformat = 'physical' AND Gro_id IN (SELECT GROUP_id
                                                                 FROM CreditGroup
                                                                 WHERE Gworkgrade = 'A'));

#3#######################################################################    
SELECT DOCUMENT_id, Sformat
FROM SalesDocument
WHERE CRELIM_id IN
				  (SELECT PARAMETER_id
                   FROM CreditLimitCheckParameter
				   WHERE Pchecktype IN ('hard check', ' no check'))
AND BLO_id IN 
	         (SELECT Rblocknumber
			  FROM BlockReason
              WHERE Rdateissued BETWEEN '2021-03-01' AND '2021-08-31');

#4########################################################################
SELECT DOCUMENT_id, sformat
FROM SalesDocument AS sd
WHERE GRO_id IN (SELECT GROUP_id
				 FROM CreditGroup
				 WHERE Gworkgrade IN  ('A', 'C', 'E') AND EMssn IN (SELECT Essn 
															        FROM EmployeeGManager
                                                                    WHERE Ename LIKE '%C%'))
AND BLO_id IN
                (SELECT Rblocknumber
                 FROM BlockReason
                 WHERE Rmotivation IN ('payment not received', 'billing blocking reason'));
                       