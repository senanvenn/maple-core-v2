
Contract MigrationHelper
Contract vars: []
Inheritance:: []
 
+-------------------------------------+------------+-----------+------+-------+----------------+---------------------------------------------------------------------------------------------------------------------------------+
|               Function              | Visibility | Modifiers | Read | Write | Internal Calls |                                                          External Calls                                                         |
+-------------------------------------+------------+-----------+------+-------+----------------+---------------------------------------------------------------------------------------------------------------------------------+
| setPendingLender(address[],address) |  external  |     []    |  []  |   []  |       []       | ['IDebtLockerLike(IMapleLoanLike(loans[i]).lender()).setPendingLender(investmentManager)', 'IMapleLoanLike(loans[i]).lender()'] |
+-------------------------------------+------------+-----------+------+-------+----------------+---------------------------------------------------------------------------------------------------------------------------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+


Contract IDebtLockerLike
Contract vars: []
Inheritance:: []
 
+---------------------------+------------+-----------+------+-------+----------------+----------------+
|          Function         | Visibility | Modifiers | Read | Write | Internal Calls | External Calls |
+---------------------------+------------+-----------+------+-------+----------------+----------------+
|       poolDelegate()      |  external  |     []    |  []  |   []  |       []       |       []       |
| setPendingLender(address) |  external  |     []    |  []  |   []  |       []       |       []       |
+---------------------------+------------+-----------+------+-------+----------------+----------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+


Contract IERC20Like
Contract vars: []
Inheritance:: []
 
+---------------------------+------------+-----------+------+-------+----------------+----------------+
|          Function         | Visibility | Modifiers | Read | Write | Internal Calls | External Calls |
+---------------------------+------------+-----------+------+-------+----------------+----------------+
|  approve(address,uint256) |  external  |     []    |  []  |   []  |       []       |       []       |
|     balanceOf(address)    |  external  |     []    |  []  |   []  |       []       |       []       |
| transfer(address,uint256) |  external  |     []    |  []  |   []  |       []       |       []       |
+---------------------------+------------+-----------+------+-------+----------------+----------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+


Contract IGlobalsLike
Contract vars: []
Inheritance:: []
 
+------------------------------------+------------+-----------+------+-------+----------------+----------------+
|              Function              | Visibility | Modifiers | Read | Write | Internal Calls | External Calls |
+------------------------------------+------------+-----------+------+-------+----------------+----------------+
| platformManagementFeeRate(address) |  external  |     []    |  []  |   []  |       []       |       []       |
+------------------------------------+------------+-----------+------+-------+----------------+----------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+


Contract IMapleLoanLike
Contract vars: []
Inheritance:: []
 
+------------------------------+------------+-----------+------+-------+----------------+----------------+
|           Function           | Visibility | Modifiers | Read | Write | Internal Calls | External Calls |
+------------------------------+------------+-----------+------+-------+----------------+----------------+
|          borrower()          |  external  |     []    |  []  |   []  |       []       |       []       |
|       claimableFunds()       |  external  |     []    |  []  |   []  |       []       |       []       |
|      closeLoan(uint256)      |  external  |     []    |  []  |   []  |       []       |       []       |
|       drawableFunds()        |  external  |     []    |  []  |   []  |       []       |       []       |
| getClosingPaymentBreakdown() |  external  |     []    |  []  |   []  |       []       |       []       |
|  getNextPaymentBreakdown()   |  external  |     []    |  []  |   []  |       []       |       []       |
|       implementation()       |  external  |     []    |  []  |   []  |       []       |       []       |
|           lender()           |  external  |     []    |  []  |   []  |       []       |       []       |
|     makePayment(uint256)     |  external  |     []    |  []  |   []  |       []       |       []       |
|     nextPaymentDueDate()     |  external  |     []    |  []  |   []  |       []       |       []       |
|      paymentInterval()       |  external  |     []    |  []  |   []  |       []       |       []       |
|       pendingLender()        |  external  |     []    |  []  |   []  |       []       |       []       |
|         principal()          |  external  |     []    |  []  |   []  |       []       |       []       |
|    upgrade(uint256,bytes)    |  external  |     []    |  []  |   []  |       []       |       []       |
+------------------------------+------------+-----------+------+-------+----------------+----------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+


Contract IPoolManagerLike
Contract vars: []
Inheritance:: []
 
+-----------------------------+------------+-----------+------+-------+----------------+----------------+
|           Function          | Visibility | Modifiers | Read | Write | Internal Calls | External Calls |
+-----------------------------+------------+-----------+------+-------+----------------+----------------+
|           asset()           |  external  |     []    |  []  |   []  |       []       |       []       |
| delegateManagementFeeRate() |  external  |     []    |  []  |   []  |       []       |       []       |
|            pool()           |  external  |     []    |  []  |   []  |       []       |       []       |
|        totalAssets()        |  external  |     []    |  []  |   []  |       []       |       []       |
+-----------------------------+------------+-----------+------+-------+----------------+----------------+

+-----------+------------+------+-------+----------------+----------------+
| Modifiers | Visibility | Read | Write | Internal Calls | External Calls |
+-----------+------------+------+-------+----------------+----------------+
+-----------+------------+------+-------+----------------+----------------+

modules/migration-helpers/contracts/MigrationHelper.sol analyzed (6 contracts)